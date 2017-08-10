FROM tomcat:8.0-jre8-alpine
# Currently, Camunda BPM is supported on Tomcat 8.0.x
# See also: https://docs.camunda.org/manual/latest/introduction/supported-environments/

ENV CAMUNDA_VERSION 7.6.2
ENV DISTRO tomcat

# Put your EE credentials into the following file
COPY camunda-enterprise-login.env .

# add Camunda EE distro
RUN export $(cat camunda-enterprise-login.env | xargs) && \
    wget -O - "https://camunda.org/enterprise-release/camunda-bpm/${DISTRO}/$(echo $CAMUNDA_VERSION | cut -c 1-3)/${CAMUNDA_VERSION}/camunda-bpm-ee-${DISTRO}-standalone-${CAMUNDA_VERSION}-ee.war" --user=${EE_USERNAME} --password=${EE_PASSWORD} | \
    tar xzf - --directory /usr/local/tomcat/webapps/camunda

# clean up
RUN rm camunda-enterprise-login.env

# TODO: edit datasource in /usr/local/tomcat/webapps/camunda/WEB-INF/applicationContext.xml

# remove     <property name="deploymentResources" value="classpath*:bpmn/*.bpmn" />

# TODO: configure & enable: <!--<ref bean="ldapIdentityProviderPlugin" />-->
