FROM tomcat:8.0-jre8
# Currently, Camunda BPM is supported on Tomcat 8.0.x
# See also: https://docs.camunda.org/manual/latest/introduction/supported-environments/

# no suffix '-ee' in VERSION!
ENV VERSION 7.7.0-alpha2
ENV DISTRO tomcat
ENV SERVER apache-tomcat-8.0.24
ENV LIB_DIR ${CATALINA_HOME}/lib/
ENV SERVER_CONFIG ${CATALINA_HOME}/conf/server.xml
ENV NEXUS https://app.camunda.com/nexus/service/local/artifact/maven/redirect

# Put your EE credentials into the following file
COPY camunda-enterprise-login.env .

# add Camunda EE components
RUN export $(cat camunda-enterprise-login.env | xargs) && \
    wget -O - "https://camunda.org/enterprise-release/camunda-bpm/${DISTRO}/$(echo $VERSION | cut -c 1-3)/${VERSION}/camunda-bpm-ee-${DISTRO}-${VERSION}-ee.tar.gz" --user=${EE_USERNAME} --password=${EE_PASSWORD} | \
    # REDO this line with stuff below: tar xzf - --directory /camunda/ server/${SERVER} --strip 2

# TODO Add BPM Bootstrap Server Listener (https://docs.camunda.org/manual/latest/installation/full/tomcat/manual/#add-bpm-bootstrap-server-listener)
# xmlstarlet, sed or the likes
{CATALINA_HOME}/conf/server.xml

  <Listener className="org.camunda.bpm.container.impl.tomcat.TomcatBpmPlatformBootstrap" />


# TODO Add services to server.xml
    <Resource name="global/camunda-bpm-platform/process-engine/ProcessEngineService!org.camunda.bpm.ProcessEngineService" auth="Container"
              type="org.camunda.bpm.ProcessEngineService"
              description="camunda BPM platform Process Engine Service"
              factory="org.camunda.bpm.container.impl.jndi.ProcessEngineServiceObjectFactory" />
              
    <Resource name="global/camunda-bpm-platform/process-engine/ProcessApplicationService!org.camunda.bpm.ProcessApplicationService" auth="Container"
              type="org.camunda.bpm.ProcessApplicationService"
              description="camunda BPM platform Process Application Service"
              factory="org.camunda.bpm.container.impl.jndi.ProcessApplicationServiceObjectFactory" />

# TODO Add Required Libraries (https://docs.camunda.org/manual/latest/installation/full/tomcat/manual/#add-required-libraries)
# untar from camunda distro
${LIB_DIR}

# TODO Add bpm-platform.xml (https://docs.camunda.org/manual/latest/installation/full/tomcat/manual/#add-bpm-platform-xml)
# untar from camunda distro
server/${SERVER}/conf/bpm-platform.xml ${CATALINA_HOME}/conf/bpm-platform.xml

# TODO Camunda Webapp: Cockpit, Tasklist and Admin (https://docs.camunda.org/manual/latest/installation/full/tomcat/manual/#cockpit-tasklist-and-admin)
# wget https://app.camunda.com/nexus/content/groups/public/org/camunda/bpm/webapp/camunda-webapp-tomcat/...
# or use unpacked folder from distro for a static image

# TODO REST API (https://docs.camunda.org/manual/latest/installation/full/tomcat/manual/#rest-api)
# wget https://app.camunda.com/nexus/content/groups/public/org/camunda/bpm/camunda-engine-rest/...
# or use unpacked folder from distro for a static image

# TODO Add H2 Console, when H2 is used
#RUN if [ "$DB_DRIVER" == "h2" ]; then camunda-h2-webapp-${VERSION}-ee.war; fi

# TODO Add example process application
# camunda-example-invoice-${VERSION}-ee.war

# add database drivers
RUN export $(cat camunda-enterprise-login.env | xargs) && \
    export GITHUB="https://raw.githubusercontent.com/camunda/camunda-bpm-platform/7.6.0" && \
    /usr/local/bin/download-database-drivers.sh "${NEXUS}?r=camunda-bpm-ee&g=org.camunda.bpm&a=camunda-database-settings&v=${VERSION}-ee&p=pom --user=${EE_USERNAME} --password=${EE_PASSWORD}"

# clean up
RUN rm camunda-enterprise-login.env

# disable automatic DB schema creation/updates
RUN sed -i 's#<property name="isAutoSchemaUpdate">true</property>#<property name="isAutoSchemaUpdate">false</property>#' /camunda/standalone/configuration/standalone.xml

# add script to wait for database startup
COPY wait-for-connection.sh /usr/local/bin/

# TODO Configure a JDBC Resource (https://docs.camunda.org/manual/latest/installation/full/tomcat/manual/#configure-a-jdbc-resource)
CMD /usr/local/bin/wait-for-connection.sh && /usr/local/bin/configure-and-run.sh
