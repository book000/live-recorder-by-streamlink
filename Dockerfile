FROM python:3-slim

# hadolint ignore=DL3008
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install curl --no-install-recommends -y && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]