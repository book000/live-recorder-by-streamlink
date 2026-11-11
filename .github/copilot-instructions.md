# Copilot Review Instructions

Follow `AGENTS.md` for project context and conventions. Write review comments in English; code comments, docs, commit messages, and PR text are English, and runtime messages stay English.

## Review checklist

- Required environment variables (`TARGET`, `URL`) are checked before any work; new required variables get the same check and error exit.
- The reconnect loop in `entrypoint.sh` is not broken and no exit condition is added casually.
- `*.sh` changes are ShellCheck-clean; flag new `# shellcheck disable` without a reason.
- `Dockerfile` changes follow Hadolint.
- No credentials, URLs, or personal data are logged or committed (for example `recorder.env`).

## Do not flag (intentional)

- The `while :; do ... sleep 5; done` loop (automatic reconnect).
- `# shellcheck disable=SC2086` before `streamlink` (`STREAMLINK_ARG` is intentionally word-split).
- Unpinned `python:3-slim` and `# hadolint ignore=DL3008`.
- The pinned Streamlink version in `requirements.txt` (managed by Renovate).
