#!/bin/bash

if [ ! -f /.tomcat_admin_created ]; then
    /camunda/create_tomcat_admin_user.sh
fi

if [ ! -f /.datasource_configured ]; then
    /camunda/configure_datasource.sh
fi


exec ${CATALINA_HOME}/bin/catalina.sh run
