FROM python:3-slim

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install curl -y
RUN pip install streamlink

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]