ARG dockerRepository
ARG branch
ARG jdkImage

FROM ${dockerRepository}/galasadev/galasa-obr-generic:${branch}

FROM ${dockerRepository}/${jdkImage}

RUN touch /var/run/docker.sock && \
    chmod 666 /var/run/docker.sock

RUN adduser --disabled-password --home /galasa galasa       && \
    chown -R galasa:galasa /galasa
    
COPY kubectl /usr/bin/kubectl

WORKDIR /galasa

USER galasa

COPY --from=0 /galasa/* /galasa/


RUN mkdir /galasa/.galasa                          && \
    touch /galasa/.galasa/bootstrap.properties     && \
    touch /galasa/.galasa/override.properties      && \
    touch /galasa/.galasa/cps.properties           && \
    touch /galasa/.galasa/dss.properties           && \
    touch /galasa/.galasa/credentials.properties   && \
    mkdir /galasa/.galasa/ras                      && \
    mkdir /galasa/load
    

COPY trace-log4j.properties /galasa/
COPY helm-post-install.sh /galasa/
    
VOLUME /galasa/.galasa
VOLUME /galasa/load

EXPOSE 9010/tcp
EXPOSE 9011/tcp
EXPOSE 2080/tcp
EXPOSE 2023/tcp
EXPOSE 8080/tcp
EXPOSE 2027/tcp
EXPOSE 2040/tcp

