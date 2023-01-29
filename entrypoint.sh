#!/bin/bash

# check if TARGET variable is set
if [[ -z "${TARGET}" ]]; then
  echo "TARGET variable is not set"
  exit 1
fi
# check if URL variable is set
if [[ -z "${URL}" ]]; then
  echo "URL variable is not set"
  exit 1
fi

if [[ -z "${STREAMLINK_ARG}" ]]; then
  STREAMLINK_ARG=""
fi

RECORDED_FILE="/data/recorded/${TARGET}"
if [[ ! -d $(dirname "${RECORDED_FILE}") ]]; then
  mkdir -p "$(dirname "${RECORDED_FILE}")"
fi

OUTPUT_DIR="/data/${TARGET}"
if [[ ! -d "${OUTPUT_DIR}" ]]; then
  mkdir -p "${OUTPUT_DIR}"
fi

while :; do
  # shellcheck disable=SC2086
  streamlink --default-stream best -o "${OUTPUT_DIR}/{title}.mp4" ${STREAMLINK_ARG} "${URL}"
  sleep 5
done