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

OUTPUT_DIR="/data/${TARGET}"
if [[ ! -d "${OUTPUT_DIR}" ]]; then
  mkdir -p "${OUTPUT_DIR}"
fi

child_pid=""
stop_signal=""
signaled_pid=""

stop() {
  if [[ -n "${stop_signal}" ]]; then
    return
  fi
  stop_signal="$1"
  if [[ -n "${child_pid}" ]]; then
    kill -s "${stop_signal}" "${child_pid}" 2>/dev/null || :
    signaled_pid="${child_pid}"
  fi
}

trap 'stop TERM' TERM
trap 'stop INT' INT
set -m

while :; do
  [[ -z "${stop_signal}" ]] || exit 0
  # shellcheck disable=SC2086
  streamlink --default-stream best -o "${OUTPUT_DIR}/{time:%Y%m%d-%H%M%S}-{id}-{title}.mp4" ${STREAMLINK_ARG} "${URL}" &
  child_pid=$!
  if [[ -n "${stop_signal}" && "${signaled_pid}" != "${child_pid}" ]]; then
    kill -s "${stop_signal}" "${child_pid}" 2>/dev/null || :
  fi
  wait "${child_pid}" || :
  if [[ -n "${stop_signal}" ]]; then
    while kill -0 "${child_pid}" 2>/dev/null; do
      wait "${child_pid}" 2>/dev/null || :
    done
    exit 0
  fi
  child_pid=""
  sleep 5 &
  child_pid=$!
  if [[ -n "${stop_signal}" && "${signaled_pid}" != "${child_pid}" ]]; then
    kill -s "${stop_signal}" "${child_pid}" 2>/dev/null || :
  fi
  wait "${child_pid}" || :
  if [[ -n "${stop_signal}" ]]; then
    while kill -0 "${child_pid}" 2>/dev/null; do
      wait "${child_pid}" 2>/dev/null || :
    done
    exit 0
  fi
  child_pid=""
done
