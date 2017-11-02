FROM tomcat:8.0-jre8

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
    wget -O - "https://camunda.org/enterprise-release/camunda-bpm/${DISTRO}/$(echo $VERSION | cut -c 1-3)/${VERSION}/camunda-webapp-ee-${DISTRO}-standalone-${VERSION}-ee.war" --user=${EE_USERNAME} --password=${EE_PASSWORD} | \
    # REDO this line with stuff below: tar xzf - --directory /camunda/ server/${SERVER} --strip 2

# add database drivers
RUN export $(cat camunda-enterprise-login.env | xargs) && \
    export GITHUB="https://raw.githubusercontent.com/camunda/camunda-bpm-platform/7.6.0" && \
    /usr/local/bin/download-database-drivers.sh "${NEXUS}?r=camunda-bpm-ee&g=org.camunda.bpm&a=camunda-database-settings&v=${VERSION}-ee&p=pom --user=${EE_USERNAME} --password=${EE_PASSWORD}"

# clean up
RUN rm camunda-enterprise-login.env

# disable automatic DB schema creation/updates
RUN sed -i 's#<property name="databaseSchemaUpdate" value="true"/>#<property name="databaseSchemaUpdate" value="false"/>#' WEB-INF/applicationContext.xml

# enable Job Executor
RUN sed -i 's#<property name="jobExecutorActivate" value="false"/>#<property name="jobExecutorActivate" value="true"/>#' WEB-INF/applicationContext.xml

# add script to wait for database startup
COPY wait-for-connection.sh /usr/local/bin/

# TODO Configure database
<bean class="org.apache.commons.dbcp.BasicDataSource"><property name="driverClassName" value="org.h2.Driver"/><property name="url" value="jdbc:h2:mem:process-engine;MVCC=TRUE;TRACE_LEVEL_FILE=0;DB_CLOSE_ON_EXIT=FALSE"/><property name="username" value="sa"/><property name="password" value=""/></bean>

CMD /usr/local/bin/wait-for-connection.sh && /usr/local/bin/configure-and-run.sh
