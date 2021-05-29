ARG obrVersion
ARG dockerRepository
ARG branch
ARG jdkImage

FROM ${dockerRepository}/galasadev/galasa-obr-generic:${obrVersion}-${branch}

FROM ${dockerRepository}/${jdkImage}

COPY --from=0 /galasa/* /galasa/

RUN useradd -u 1000 -d /galasa galasa              && \
    chown -R galasa:galasa /galasa
    
RUN touch /var/run/docker.sock && \
    chmod 666 /var/run/docker.sock

WORKDIR /galasa

USER galasa

RUN mkdir /galasa/.galasa                          && \
    touch /galasa/.galasa/bootstrap.properties     && \
    touch /galasa/.galasa/override.properties      && \
    touch /galasa/.galasa/cps.properties           && \
    touch /galasa/.galasa/dss.properties           && \
    touch /galasa/.galasa/credentials.properties   && \
    mkdir /galasa/.galasa/ras                      && \
    mkdir /galasa/load
    

COPY trace-log4j.properties /galasa/
    
VOLUME /galasa/.galasa
VOLUME /galasa/load

EXPOSE 9010/tcp
EXPOSE 9011/tcp
EXPOSE 2080/tcp
EXPOSE 2023/tcp
EXPOSE 8080/tcp
EXPOSE 2027/tcp
EXPOSE 2040/tcp

