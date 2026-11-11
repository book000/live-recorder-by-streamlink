# AGENTS.md

Guidance for AI coding agents and contributors. `CLAUDE.md` imports this file, and `.github/copilot-instructions.md` adds the review checklist.

## Language

- All deliverables are written in **English**: commit messages, PR/Issue titles and bodies, review comments, code comments and docstrings, and documentation (`README.md`, `AGENTS.md`, etc.).
- Exceptions (keep as is): quotations, technical identifiers, generated files, and external source text.
- Runtime messages (logs, errors) are English.
- Do not rewrite Git history to change the language of past commits.

## Overview

A Docker image that records a live stream with Streamlink and reconnects when it drops. It is meant to run only in Docker. There are no automated tests; quality relies on ShellCheck and Hadolint in CI.

## Commands

```bash
shellcheck entrypoint.sh      # lint the script
hadolint Dockerfile           # lint the Dockerfile
docker build -t live-recorder .
```

## Structure

- `entrypoint.sh`: the whole recording logic. It requires `TARGET` and `URL` (exits 1 if unset), accepts optional `STREAMLINK_ARG`, creates `/data/${TARGET}`, then loops `streamlink --default-stream best -o "/data/${TARGET}/{title}.mp4" ...` with a 5-second sleep between runs.
- `Dockerfile`: `python:3-slim` plus curl, `requirements.txt` (pins Streamlink, updated by Renovate), and `entrypoint.sh` as the entrypoint.
- `docker-compose.yml`: example service using `recorder.env` (git-ignored) and a bind-mounted `data` volume.
- `.github/workflows/`: `shell-ci.yml` (ShellCheck on changed `*.sh`), `hadolint-ci.yml`, `docker.yml` (build and publish through `book000/templates`), `add-reviewer.yml`.

## Conventions

- Keep `entrypoint.sh` ShellCheck-clean. The existing `# shellcheck disable=SC2086` is intentional: `STREAMLINK_ARG` must be word-split. Do not add other disables without a reason.
- Validate required environment variables before doing any work, and do not log their values.
- Keep the infinite reconnect loop; it is the intended design.
- Keep the base image as `python:3-slim` (unpinned on purpose) and the existing `# hadolint ignore=DL3008`.
- Update `README.md` when behavior or configuration changes.
- Commits follow [Conventional Commits](https://www.conventionalcommits.org/); branches follow [Conventional Branch](https://conventional-branch.github.io) short form (`feat/...`, `fix/...`).
- Do not commit to Renovate PRs. Never commit secrets (`recorder.env`).
