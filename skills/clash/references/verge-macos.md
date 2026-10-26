# Clash Verge service logs on macOS

Read this when the core runs as a privileged service and the visible app logs do not contain connection failures.

## Locate the actual sources

- User data usually lives at `~/Library/Application Support/io.github.clash-verge-rev.clash-verge-rev/`.
- `logs/latest.log` is the GUI/app log. Older `logs/sidecar/*` may belong to a previous execution mode; verify timestamps.
- A `service-logs/` directory can be empty even when the service has persisted core logs elsewhere.
- The service root can be `/Library/Application Support/clash-verge-service/`, with protected per-user subdirectories. Never change its permissions to inspect logs.
- The core controller socket can be `/var/run/clash-verge-service/users/<uid>/verge-mihomo.sock`. A separate management service uses `/var/run/clash-verge-service/service.sock`. These are different APIs.
- Check process arguments and launchd configuration for the actual runtime paths. Directory layouts and protocols can change between builds.

## Supported snapshot interface

Verified against Clash Verge Service IPC **v2.7.6**, protocol **2.5**. This is a version-specific adapter, not a guarantee for all Verge releases.

Run from the skill directory:

```bash
python3 scripts/clash.py snapshot --output /tmp/clash-history.log
python3 scripts/clash.py analyze /tmp/clash-history.log --timezone Asia/Shanghai --contains chatgpt
```

The helper uses the caller's real Unix UID/GID and actual app-data directory to authenticate. It sends GET `/clash/log-snapshot` with `X-Clash-Verge-Service-Protocol: 2.5` and a JSON envelope:

```json
{
  "credentials": {
    "identity": {"Unix": {"uid": 501, "gid": 20}},
    "app_data_dir": "/actual/current/user/app-data-directory",
    "token": null
  },
  "payload": null
}
```

UID/GID above are illustrative. Do not impersonate a different user or bypass an authentication rejection. On this protocol, Unix peer credentials authenticate the caller; Windows uses a different identity mechanism and is not implemented by this helper.

Successful responses contain hex-encoded log bytes in `data`. The server returns at most the last **4 MiB of the current `service_latest.log`**, possibly dropping a partial first line. It is not the complete set of rotated logs. The helper saves a protected `.meta.json` sidecar describing capture time, adapter version, and truncation limits.

GET `/clash/logs` is a bounded in-memory buffer, not a historical archive. GUI Logs may display only this buffer. A copied "diagnostic info" summary is also not necessarily a core-log export.

If the snapshot is insufficient, determine the owner's log directory and inspect rotated files using existing authorized filesystem access or the client's supported export facilities. A permission error means those files remain uninspected; report that limit. Do not request passwords in chat, weaken permissions, or assume that elevating outside an agent sandbox also grants macOS administrator privileges.

If the protocol mismatches, check the installed version and its official source/API documentation. Do not guess header versions or disable authentication. `--protocol` exists for a verified compatible revision. `--service-socket` and `--app-data` support confirmed non-default locations.

## References

- [Official service IPC source, v2.7.6](https://github.com/clash-verge-rev/clash-verge-service-ipc/tree/v2.7.6): `src/core/server.rs` (`GetClashLogSnapshot`, `read_log_snapshot`), `src/core/structure.rs` (credential envelope), and `src/lib.rs` (protocol constants).
- [Clash Verge source](https://github.com/clash-verge-rev/clash-verge-rev): `src-tauri/src/core/service.rs` and `owner_identity.rs` show the normal caller and current-user credential construction. Consult the installed version's corresponding source when adapting.
