FROM camunda/camunda-bpm-platform:wildfly-7.8.0
# inherit shell scripts from Community Edition image

# no suffix '-ee' in CAMUNDA_VERSION!
ENV CAMUNDA_VERSION 7.8.6

ARG MANAGEMENT_USERNAME
ARG MANAGEMENT_PASSWORD

# remove Community Edition
RUN rm -rf /camunda

# Put your EE credentials into the following file
COPY camunda-enterprise-login.env .

# add Camunda EE distro
RUN export $(cat camunda-enterprise-login.env | xargs) && \
    wget -O - "https://camunda.org/enterprise-release/camunda-bpm/${DISTRO}/$(echo $CAMUNDA_VERSION | cut -c 1-3)/${CAMUNDA_VERSION}/camunda-bpm-ee-${DISTRO}-${CAMUNDA_VERSION}-ee.tar.gz" --user=${EE_USERNAME} --password=${EE_PASSWORD} | \
    tar xzf - --directory /camunda/ server/${SERVER} --strip 2

# remove H2 Console, when H2 is not used

RUN if [ "$DB_DRIVER" != "h2" ]; then rm /camunda/standalone/deployments/camunda-h2-webapp-${CAMUNDA_VERSION}-ee.war; fi

# remove example process application
#RUN rm /camunda/standalone/deployments/camunda-example-invoice-${CAMUNDA_VERSION}-ee.war

# re-add database drivers
RUN export $(cat camunda-enterprise-login.env | xargs) && \
    export GITHUB="https://raw.githubusercontent.com/camunda/camunda-bpm-platform/7.6.0" && \
    /usr/local/bin/download-database-drivers.sh "${NEXUS}?r=camunda-bpm-ee&g=org.camunda.bpm&a=camunda-database-settings&v=${CAMUNDA_VERSION}-ee&p=pom --user=${EE_USERNAME} --password=${EE_PASSWORD}"

# clean up
RUN rm camunda-enterprise-login.env

# disable automatic DB schema creation/updates
RUN sed -i 's#<property name="isAutoSchemaUpdate">true</property>#<property name="isAutoSchemaUpdate">false</property>#' /camunda/standalone/configuration/standalone.xml

# Add management user to access Management Web Console and to allow deployment with wilfly-maven-plugin

RUN if [ "$MANAGEMENT_USERNAME" != "" ]; then ./bin/add-user.sh $MANAGEMENT_USERNAME $MANAGEMENT_PASSWORD; fi

# add script to wait for database startup
COPY wait-for-connection.sh /usr/local/bin/

CMD /usr/local/bin/wait-for-connection.sh && /usr/local/bin/configure-and-run.sh
