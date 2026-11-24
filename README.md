# live-recorder-by-streamlink

A Docker image that records a live stream with [Streamlink](https://streamlink.github.io/) and keeps reconnecting when the stream drops.

The image includes FFmpeg so Streamlink can mux supported streams with separate video and audio tracks.

## How it works

`entrypoint.sh` requires the `TARGET` and `URL` environment variables (it exits with an error if either is unset), then loops forever:

1. Run `streamlink --default-stream best -o "/data/${TARGET}/{time:%Y%m%d-%H%M%S}-{id}-{title}.mp4" ${STREAMLINK_ARG} "${URL}"`.
2. Wait 5 seconds and run it again, whether Streamlink succeeded or failed.

On `TERM` or `INT`, the entrypoint forwards the signal to Streamlink and waits for it to exit without reconnecting. A stop during the reconnect delay ends the delay promptly. Allow enough container stop grace time for Streamlink to finish cleaning up.

Recordings are written to `/data/${TARGET}/` inside the container, so mount a volume on `/data` to keep them.

Each run writes a new file named `<start time>-<stream ID>-<title>.mp4`, so existing recordings are never overwritten. A reconnect to the same broadcast starts a new file, so one broadcast can be split across several files.

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
