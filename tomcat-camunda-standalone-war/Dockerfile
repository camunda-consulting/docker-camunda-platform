FROM tomcat

ENV NEXUS https://app.camunda.com/nexus/service/local/artifact/maven/redirect
ENV VERSION 7.7.0

RUN apt-get update && apt-get install -y xmlstarlet

ADD bin/*.sh /camunda/

# Delete default root webapp and replace with camunda
RUN rm -rf ${CATALINA_HOME}/webapps/ROOT
RUN wget --output-document=/camunda.war "https://camunda.org/release/camunda-bpm/tomcat/7.7/amunda-webapp-tomcat-standalone-7.7.0.war" && unzip -qq /camunda.war -d ${CATALINA_HOME}/webapps/ROOT

# local alternative during playing around
#ADD camunda.war /
#RUN unzip -qq /camunda.war -d ${CATALINA_HOME}/webapps/ROOT

# add database drivers
RUN /camunda/download_database_drivers.sh "${NEXUS}?r=public&g=org.camunda.bpm&a=camunda-database-settings&v=${VERSION}&p=pom"


#EXPOSE 8080
CMD ["/camunda/configure_and_run.sh"]