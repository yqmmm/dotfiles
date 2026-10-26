---
name: clash
description: Inspect and troubleshoot Clash, Mihomo, and Clash Verge proxy routing, nodes, connectivity, and historical logs. Use for proxy failures, upstream timeouts, group selections, or requested routing changes.
---

# Clash / Mihomo

Work with the user's existing proxy client and configuration. This skill works with any agent that can read files and run Python 3.9+; it has no dependency on a particular agent application or tool namespace. Resolve script and reference paths relative to this file.

## Inspect and diagnose

- Discover the running client, core, actual controller/socket, configuration source, and log locations. Distinguish GUI logs, core logs, service logs, and live in-memory buffers. For Clash Verge on macOS, read [the service-log reference](references/verge-macos.md); an unreadable service directory does not mean logs cannot be retrieved.
- Use `python3 scripts/clash.py status` for the running mode, TUN state, selector chains, and retained health-check timestamps. Auto-detection supports the macOS Verge core socket; elsewhere provide `--socket PATH` or `--controller URL` before the command. Set `CLASH_SECRET` in the environment if the core controller requires a bearer secret. Do not print it.
- Retrieve historical logs before changing nodes, restarting the core, or changing log levels. Prefer an existing export or a supported, authenticated snapshot API. Do not treat a live buffer as full history. Save raw logs locally with restricted permissions.
- Analyze a saved log with `python3 scripts/clash.py analyze FILE --timezone Asia/Shanghai --since '2026-10-26T09:00:00' --until '2026-10-26T18:00:00'`. Replace the date, window, and timezone with the user's requested period. Add `--contains chatgpt` to focus on relevant records. Summaries include timestamps, groups, processes, upstream endpoints, and failure categories; focused searches include a bounded set of redacted samples with source line numbers.
- Identify who initiated each failed connection from its process field and destination. A failure by an updater or browser is not evidence that another application failed. Compare system sleep/wake and interface/DNS events when they overlap the requested period.
- To test a specific node now, use `python3 scripts/clash.py delay 'NODE NAME'`. This makes a real network request, records a new health result, and does not change the selected node. A successful current test does not establish historical health or application-specific reachability.

## Interpret evidence

- Distinguish the rule/group, nested group selection, node label, upstream server, and destination service. An IP alone does not establish the exit country. Match the full upstream endpoint against node configuration or provider data, without exposing passwords or subscription URLs. Several nodes may share a hostname/IP and use different ports.
- Current selectors, configuration, and DNS answers describe current state; do not silently apply them to an earlier period. Check file timestamps, rotation, provider refreshes, and retained selection history when making a historical attribution.
- `failed to create session: dial tcp UPSTREAM:PORT: i/o timeout` establishes a failed connection to the proxy upstream. It does not by itself distinguish server outage, path failure, or a local network problem.
- `network is unreachable` / `no route to host` may arise during wake/interface recovery. A WebSocket close code or TLS reset in an application is not sufficient to identify which component failed.
- Warning-level logs omit successful traffic. State the log's coverage, level, truncation, and remaining blind spots. Do not infer a continuous outage, a healthy node, or causation from absent errors, process uptime, or temporal coincidence alone.

## Make requested changes

Diagnosis does not authorize changing proxy selection, rules, DNS, TUN, sleep settings, or subscriptions. When the user requests a change, identify its narrow scope and the authoritative source first. Generated runtime YAML can be overwritten by profile refreshes; update the source profile/override or the user's configuration generator instead.

Preserve the prior value or a local backup, apply the requested change through the client's supported API/configuration flow, and verify both the selected route and the affected application's connectivity. If a test fails, restore the previous value when that is within the authorized scope. Do not restart the whole client merely to test a node. The bundled helper intentionally exposes inspection and testing only; use the normal API/client for authorized mutations.

## Privacy and delivery

Do not dump full configurations, bearer secrets, node passwords, or subscription links into chat or committed files. Raw diagnostic logs can contain private destinations and process names; keep them local and quote only relevant redacted excerpts. Summarize what is proved, what is inferred, and what the next useful check would resolve. Include source timestamps and line numbers when they affect the conclusion.

## Portability

The directory itself is the distributable unit. Copy or symlink it into the target agent's supported skill directory, or have that agent read this file directly. Installation/discovery paths vary by agent; verify its documentation instead of assuming one directory works everywhere. Keep agent-specific registration outside this directory. Do not embed machine usernames, live endpoints, subscription credentials, or incident logs in the skill.
