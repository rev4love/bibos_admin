FROM python:2

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y sqlite3

# Configure locale
RUN apt-get update && apt-get install -y locales
RUN echo "en_GB.UTF8 UTF-8" > /etc/locale.gen
RUN locale-gen
RUN update-locale LANG=en_GB.utf8

ADD . /usr/src/app

RUN ./scripts/install.sh
EXPOSE 8000
CMD ["./start.sh"]
