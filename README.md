# live-recorder-by-streamlink

A Docker image that records a live stream with [Streamlink](https://streamlink.github.io/) and keeps reconnecting when the stream drops.

## How it works

`entrypoint.sh` requires the `TARGET` and `URL` environment variables (it exits with an error if either is unset), then loops forever:

1. Run `streamlink --default-stream best -o "/data/${TARGET}/{title}.mp4" ${STREAMLINK_ARG} "${URL}"`.
2. Wait 5 seconds and run it again, whether Streamlink succeeded or failed.

Recordings are written to `/data/${TARGET}/` inside the container, so mount a volume on `/data` to keep them.

## Environment variables

| Name | Required | Description |
|---|---|---|
| `TARGET` | Yes | Name of the output subdirectory under `/data` |
| `URL` | Yes | URL of the live stream passed to Streamlink |
| `STREAMLINK_ARG` | No | Extra Streamlink options, split on whitespace (for example `--retry-streams 5`) |

## Usage

```bash
docker build -t live-recorder .
docker run -d --name live-recorder \
  -e TARGET=example \
  -e URL='https://example.com/live' \
  -v "$PWD/data:/data" \
  live-recorder
```

The Streamlink version is pinned in `requirements.txt` and updated by Renovate.

## Warning / Disclaimer

The developer is not responsible for any problems caused by the user using this project.

## License

The license for this project is [MIT License](LICENSE).
