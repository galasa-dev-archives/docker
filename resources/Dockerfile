ARG dockerRepository
FROM ${dockerRepository}/library/httpd:2.4
ARG distBranch
ARG version

ENV DEBIAN_FRONTEND="noninteractive" TZ="Europe/London"
RUN apt-get update && apt-get install -y wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN rm -v /usr/local/apache2/htdocs/*
COPY httpd.conf /usr/local/apache2/conf/httpd.conf

RUN echo ${version} - ${distBranch}

RUN wget --no-check-certificate -q https://galasadev-cicsk8s.hursley.ibm.com/${distBranch}/maven/isolated/dev/galasa/galasa-isolated/${version}/galasa-isolated-${version}.zip -O /usr/local/apache2/htdocs/isolated-${version}.zip
RUN ln -sf /usr/local/apache2/htdocs/isolated-${version}.zip /usr/local/apache2/htdocs/isolated.zip

