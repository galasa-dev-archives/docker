ARG dockerRepository
FROM httpd:2.4

ENV DEBIAN_FRONTEND="noninteractive" TZ="Europe/London"
RUN apt-get update && apt-get install -y wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN rm -v /usr/local/apache2/htdocs/*
COPY httpd.conf /usr/local/apache2/conf/httpd.conf

RUN wget --no-check-certificate -q https://galasadev-cicsk8s.hursley.ibm.com/release/maven/isolated/dev/galasa/galasa-isolated/0.19.0/galasa-isolated-0.19.0.zip -O /usr/local/apache2/htdocs/isolated-0.19.0.zip
RUN ln -sf /usr/local/apache2/htdocs/isolated-0.19.0.zip /usr/local/apache2/htdocs/isolated.zip

