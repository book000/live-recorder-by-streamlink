FROM python:3-slim

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install software-properties-common -y
RUN apt-get update
RUN add-apt-repository ppa:nilarimogard/webupd8
RUN apt-get update
RUN apt-get install curl streamlink -y

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]