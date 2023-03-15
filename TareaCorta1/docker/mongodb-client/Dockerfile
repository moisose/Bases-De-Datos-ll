FROM ubuntu:latest

RUN apt-get update && apt-get install -y gnupg wget

RUN wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | apt-key add -

RUN echo "deb http://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list

RUN apt-get update && apt-get install -y mongodb-mongosh

WORKDIR /app
CMD ["mongosh"]
