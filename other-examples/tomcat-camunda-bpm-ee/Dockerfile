# Docker Image for Camunda BPM Enterprise Edition as a shared engine
# inside the latest version of Apache Tomcat 9

# It basically follows Camunda's guide on how to
# "Install the Full Distribution on a Tomcat Application Server manually":
# https://docs.camunda.org/manual/latest/installation/full/tomcat/manual/

FROM tomcat:9-jre8-alpine
# src: https://github.com/docker-library/tomcat/blob/master/9.0/jre8-alpine/Dockerfile

# When updating to a new Tomcat version, check the diff of the server.xml
# that shipps with the Camunda distro and the one shipped with Tomcat, e.g.
# $ docker run tomcat:9-jre8-alpine cat /usr/local/tomcat/conf/server.xml > server.orig-tomcat-9.xml
# $ tar xzOf camunda-bpm-ee-tomcat-7.9.2-ee.tar.gz server/apache-tomcat-9.0.5/conf/server.xml > server.orig-camunda-7.9.2-ee-tomcat-9.xml
# $ diff server.orig-camunda-7.9.2-ee-tomcat-9.xml server.orig-tomcat-9.xml

ARG EE_USERNAME
ARG EE_PASSWORD

# Set the desired Camunda BPM version here.
# no suffix '-ee' in VERSION, but in EE variable!
ENV VERSION 7.9.2
# leave EE empty for Community Edition
ENV EE -ee

ENV DISTRO tomcat
ENV SERVER apache-tomcat-9.0.5
ENV LIB_DIR ${CATALINA_HOME}/lib
ENV SERVER_CONFIG ${CATALINA_HOME}/conf/server.xml
ENV NEXUS https://app.camunda.com/nexus/service/local/artifact/maven/redirect

# Git repo of the Camunda BPM Community Edition Docker images
ENV GITHUB "https://raw.githubusercontent.com/camunda/docker-camunda-bpm-platform"


# Remove Tomcat default webapps as recommended in https://tomcat.apache.org/tomcat-8.0-doc/security-howto.html
RUN rm -r ${CATALINA_HOME}/webapps/ROOT \
          ${CATALINA_HOME}/webapps/docs \
          ${CATALINA_HOME}/webapps/examples \
          ${CATALINA_HOME}/webapps/manager \
          ${CATALINA_HOME}/webapps/host-manager

# install a wget version that supports redirect, SSL and login
# and XMLStarlet Toolkit (required by configure-and-run.sh)
RUN apk --no-cache add \
    ca-certificates \
    wget \
    xmlstarlet \
    && update-ca-certificates

# add Camunda distro from Camunda Nexus
RUN mkdir "/camunda-bpm-distro/" && \
    wget -O - --no-verbose --user="${EE_USERNAME}" --password="${EE_PASSWORD}" \
        "${NEXUS}?r=camunda-bpm${EE}&g=org.camunda.bpm.${DISTRO}&a=camunda-bpm${EE}-${DISTRO}&v=${VERSION}${EE}&p=tar.gz" \
    | \
    tar xzf - -C "/camunda-bpm-distro/" \
    && \
    mv /camunda-bpm-distro/lib/* ${LIB_DIR} && \
    mv /camunda-bpm-distro/server/${SERVER}/conf/server.xml ${SERVER_CONFIG} && \
    mv /camunda-bpm-distro/server/${SERVER}/conf/bpm-platform.xml ${CATALINA_HOME}/conf/ && \
    mv /camunda-bpm-distro/server/${SERVER}/webapps/camunda-welcome ${CATALINA_HOME}/webapps/ && \
    mv /camunda-bpm-distro/server/${SERVER}/webapps/camunda ${CATALINA_HOME}/webapps/ && \
    mv /camunda-bpm-distro/server/${SERVER}/webapps/engine-rest ${CATALINA_HOME}/webapps/ && \
    mv /camunda-bpm-distro/server/${SERVER}/webapps/h2 ${CATALINA_HOME}/webapps/ && \
    rm -r /camunda-bpm-distro

# add database drivers with script from CE Docker image
RUN wget -O - --no-verbose \
      "${GITHUB}/master/bin/download-database-drivers.sh" \
    | bash -s \
      "${NEXUS}?r=camunda-bpm${EE}&g=org.camunda.bpm&a=camunda-database-settings&v=${VERSION}${EE}&p=pom --user=${EE_USERNAME} --password=${EE_PASSWORD}"

# add datasource configuration script from CE Docker image,
# customize it to run with the Tomcat base image,
# and remove H2 stuff when not needed
RUN wget -O - --no-verbose \
      "${GITHUB}/master/bin/configure-and-run.sh" \
    | head -n -1 \
    > /usr/local/bin/configure-and-run.sh \
    && \
    echo -e "\n\
# remove H2 webapp when not needed\n\
if [ \$DB_DRIVER != \"org.h2.Driver\" ]; then\n\
  rm -r \${CATALINA_HOME}/webapps/h2 ${LIB_DIR}/h2-*.jar;\n\
fi\n\
\n\
exec catalina.sh run" \
    >> /usr/local/bin/configure-and-run.sh \
	&& chmod +x /usr/local/bin/configure-and-run.sh

# Configures a JDBC DataSource (https://docs.camunda.org/manual/latest/installation/full/tomcat/manual/#configure-a-jdbc-resource)
# based on environment variables DB_DRIVER, DB_URL, DB_USERNAME, DB_PASSWORD
# and then starts Tomcat
CMD ["configure-and-run.sh"]