ARG dockerRepository
ARG branch
ARG platform

FROM ${dockerRepository}/galasadev/galasa-boot-embedded-${platform}:${branch}

USER root

COPY carootcert.der $JAVA_HOME/lib/security
COPY caintermediatecert.der $JAVA_HOME/lib/security

RUN \
    cd $JAVA_HOME/lib/security \
    && keytool -keystore cacerts -storepass changeit -noprompt -trustcacerts -importcert -alias ibmca -file carootcert.der \
    && keytool -keystore cacerts -storepass changeit -noprompt -trustcacerts -importcert -alias ibminter -file caintermediatecert.der

WORKDIR /galasa

USER galasa

