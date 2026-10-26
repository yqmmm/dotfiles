#!/usr/bin/env python3
"""Portable, read-only Clash/Mihomo inspection and local log analysis (stdlib only)."""
import argparse
import collections
import datetime as dt
import http.client
import json
import os
from pathlib import Path
import re
import socket
import sys
from urllib.parse import quote, urlencode, urlsplit
from zoneinfo import ZoneInfo

MAX_RESPONSE = 10 * 1024 * 1024
APP_DATA = Path.home() / 'Library/Application Support/io.github.clash-verge-rev.clash-verge-rev'


def redact(text):
    text = re.sub(r'https?://[^\s"\'\\]+', '<url omitted>', text)
    return re.sub(r'(?i)((?:authorization|password|secret|token)\s*[:=]\s*)[^\s,}"\']+', r'\1<redacted>', text)


def request(path, *, unix_socket=None, controller=None, body=None, headers=None, timeout=12):
    headers = dict(headers or {})
    if unix_socket:
        if not hasattr(socket, 'AF_UNIX'):
            raise ValueError('Unix sockets are unavailable; provide --controller for the core API.')
        conn = http.client.HTTPConnection('localhost', timeout=timeout)
        conn.sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        conn.sock.settimeout(timeout)
        try:
            conn.sock.connect(str(unix_socket))
        except Exception:
            conn.close()
            raise
    else:
        url = urlsplit(controller or '')
        if url.scheme not in ('http', 'https') or not url.hostname or url.username or url.password or url.query or url.fragment:
            raise ValueError('Controller must be an http(s) URL without credentials, query, or fragment.')
        cls = http.client.HTTPSConnection if url.scheme == 'https' else http.client.HTTPConnection
        conn = cls(url.hostname, url.port, timeout=timeout)
        path = url.path.rstrip('/') + path
    try:
        conn.request('GET', path, json.dumps(body) if body is not None else None, headers)
        response = conn.getresponse()
        raw = response.read(MAX_RESPONSE + 1)
        if len(raw) > MAX_RESPONSE:
            raise ValueError('Response exceeds the 10 MiB inspection limit.')
        if response.status != 200:
            raise ValueError('API returned HTTP %s: %s' % (response.status, redact(raw.decode(errors='replace')[:250])))
        return json.loads(raw)
    finally:
        conn.close()


def core_get(args, path):
    sock = args.socket
    if not sock and not args.controller:
        if not hasattr(os, 'getuid'):
            raise ValueError('Provide --controller or --socket for this platform.')
        candidate = Path('/var/run/clash-verge-service/users') / str(os.getuid()) / 'verge-mihomo.sock'
        if not candidate.exists():
            raise ValueError('No default Verge core socket found. Provide --socket PATH or --controller URL.')
        sock = candidate
    secret = os.environ.get('CLASH_SECRET')
    return request(path, unix_socket=sock, controller=args.controller,
                   headers={'Authorization': 'Bearer ' + secret} if secret else {})


def status(args):
    config = core_get(args, '/configs')
    proxies = core_get(args, '/proxies').get('proxies', {})
    groups = []
    for name, proxy in proxies.items():
        if 'now' not in proxy:
            continue
        chain, seen, current = [], set(), name
        while current in proxies and current not in seen:
            seen.add(current)
            item = proxies[current]
            chain.append({'name': current, 'type': item.get('type'), 'alive': item.get('alive'),
                          'history': item.get('history', [])[-3:]})
            current = item.get('now')
        groups.append({'group': name, 'chain': chain, 'cycle': current in seen})
    return {'captured_at': dt.datetime.now(dt.timezone.utc).isoformat(),
            'mode': config.get('mode'), 'log_level': config.get('log-level'),
            'mixed_port': config.get('mixed-port'),
            'tun': {k: config.get('tun', {}).get(k) for k in ('enable', 'stack', 'auto-route')},
            'groups': groups, 'note': 'Current state and retained test history; not historical outage proof.'}


def write_private(path, content):
    fd = os.open(str(path), os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
    with os.fdopen(fd, 'wb') as stream:
        stream.write(content)


def snapshot(args):
    if not hasattr(os, 'getuid'):
        raise ValueError('This service snapshot adapter requires Unix peer credentials.')
    out = Path(args.output).expanduser()
    meta = Path(str(out) + '.meta.json')
    if out.exists() or meta.exists():
        raise ValueError('Output or metadata already exists; choose a new output path.')
    body = {'credentials': {'identity': {'Unix': {'uid': os.getuid(), 'gid': os.getgid()}},
                            'app_data_dir': str(Path(args.app_data).expanduser().resolve()), 'token': None},
            'payload': None}
    result = request('/clash/log-snapshot', unix_socket=args.service_socket, body=body,
                     headers={'X-Clash-Verge-Service-Protocol': args.protocol, 'Content-Type': 'application/json'})
    if result.get('code') != 0:
        raise ValueError('Service rejected snapshot: %s; verify installed protocol and owner access.' % redact(str(result.get('message'))))
    content = bytes.fromhex(result['data'])
    info = {'captured_at': dt.datetime.now(dt.timezone.utc).isoformat(), 'protocol': args.protocol,
            'source': '/clash/log-snapshot', 'bytes': len(content),
            'coverage_limit': 'Current service_latest.log tail only, at most 4 MiB; rotated files not included.'}
    write_private(out, content)
    write_private(meta, (json.dumps(info, indent=2) + '\n').encode())
    return dict(info, output=str(out), metadata=str(meta))


def parsed_time(text, timezone):
    # Mihomo emits nanoseconds; Python 3.9 accepts only microsecond precision.
    text = re.sub(r'(\.\d{6})\d+(?=(?:[+-]\d{2}:\d{2})?$)', r'\1', text.replace('Z', '+00:00'))
    value = dt.datetime.fromisoformat(text)
    return value if value.tzinfo else value.replace(tzinfo=timezone)


def analyze(args):
    timezone = ZoneInfo(args.timezone)
    since = parsed_time(args.since, timezone) if args.since else None
    until = parsed_time(args.until, timezone) if args.until else None
    if since and until and since > until:
        raise ValueError('--since must precede --until.')
    groups, processes, upstreams, errors = (collections.Counter() for _ in range(4))
    count, unparsed, coverage_min, coverage_max, samples = 0, 0, None, None, []
    with Path(args.file).expanduser().open(errors='replace') as stream:
        for number, line in enumerate(stream, 1):
            match = re.search(r'time="([^"]+)"', line) or re.match(r'^\[([^]]+)\]', line)
            try:
                stamp = parsed_time(match.group(1), timezone) if match else None
            except ValueError:
                stamp = None
            if stamp is None:
                unparsed += 1
                continue
            coverage_min = min(coverage_min, stamp) if coverage_min else stamp
            coverage_max = max(coverage_max, stamp) if coverage_max else stamp
            if (since and stamp < since) or (until and stamp >= until):
                continue
            if args.contains and args.contains.casefold() not in line.casefold():
                continue
            count += 1
            group = re.search(r'\[(?:TCP|UDP)\] dial (.*?) \(match', line)
            process = re.search(r'\(([^()]*)\)\s*-->', line)
            upstream = re.search(r'failed to create session: dial tcp (\[[^]]+\]:\d+|[^ :]+:\d+)', line)
            groups[group.group(1) if group else '(unavailable)'] += 1
            processes[process.group(1) if process else '(unavailable)'] += 1
            if upstream:
                upstreams[upstream.group(1)] += 1
            for category in ('i/o timeout', 'context deadline exceeded', 'network is unreachable',
                             'no route to host', 'connection refused', 'reset by peer', 'EOF'):
                if category in line:
                    errors[category] += 1
            if args.contains and len(samples) < args.samples:
                samples.append({'line': number, 'time': stamp.astimezone(timezone).isoformat(),
                                'text': redact(line.strip())[:1600]})
    def display(value):
        return value.astimezone(timezone).isoformat() if value else None
    return {'file': str(Path(args.file).expanduser()), 'timezone': args.timezone,
            'coverage_start': display(coverage_min), 'coverage_end': display(coverage_max),
            'matched_records': count, 'unparsed_lines': unparsed,
            'groups': dict(groups.most_common()), 'processes': dict(processes.most_common()),
            'upstream_session_failures': dict(upstreams.most_common()),
            'error_categories': dict(errors.most_common()), 'samples': samples,
            'note': 'Counts are log records, not unique outages. Categories can overlap. Until is exclusive.'}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    transport = parser.add_mutually_exclusive_group()
    transport.add_argument('--socket', help='Core controller Unix socket')
    transport.add_argument('--controller', help='Core HTTP(S) controller URL; secret via CLASH_SECRET')
    commands = parser.add_subparsers(dest='command', required=True)
    commands.add_parser('status', help='Read current routing groups and retained health history')
    delay = commands.add_parser('delay', help='Test one named node without switching selection')
    delay.add_argument('node')
    delay.add_argument('--url', default='https://www.gstatic.com/generate_204')
    snap = commands.add_parser('snapshot', help='Export macOS Verge service historical log tail')
    snap.add_argument('--output', required=True)
    snap.add_argument('--service-socket', default='/var/run/clash-verge-service/service.sock')
    snap.add_argument('--app-data', default=str(APP_DATA))
    snap.add_argument('--protocol', default='2.5', help='Only change after verifying installed protocol')
    log = commands.add_parser('analyze', help='Summarize a saved log, optionally focus by literal text')
    log.add_argument('file')
    log.add_argument('--timezone', default='UTC', help='IANA timezone for display and unzoned timestamps')
    log.add_argument('--since')
    log.add_argument('--until')
    log.add_argument('--contains')
    log.add_argument('--samples', type=int, choices=range(0, 21), default=5, metavar='0..20')
    args = parser.parse_args()
    try:
        if args.command == 'status':
            result = status(args)
        elif args.command == 'snapshot':
            result = snapshot(args)
        elif args.command == 'analyze':
            result = analyze(args)
        else:
            target = urlsplit(args.url)
            if target.scheme not in ('http', 'https') or not target.hostname or target.username or target.password or target.fragment:
                raise ValueError('Test URL must be HTTP(S), without embedded credentials or fragment.')
            result = {'node': args.node, 'result': core_get(args, '/proxies/' + quote(args.node, safe='') + '/delay?' +
                      urlencode({'timeout': 6000, 'url': args.url})), 'note': 'Current test only; selection unchanged.'}
        print(json.dumps(result, indent=2, ensure_ascii=False))
    except (OSError, ValueError, KeyError, http.client.HTTPException) as error:
        print(json.dumps({'error': redact(str(error))}, ensure_ascii=False), file=sys.stderr)
        return 1
    return 0


if __name__ == '__main__':
    sys.exit(main())
