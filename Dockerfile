
FROM python:3.7
# Copies your code file from your action repository to the filesystem path `/` of the container

WORKDIR /app
COPY requirements.txt /app/

RUN pip install -r requirements.txt

RUN apt-get -y -qq update && \
	apt-get install -y -qq curl && \
	apt-get clean

RUN curl -o /usr/local/bin/jq http://stedolan.github.io/jq/download/linux64/jq && \
  chmod +x /usr/local/bin/jq

COPY . /app
RUN chmod +x /app/entrypoint.sh
# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/bin/bash", "/app/entrypoint.sh"]
