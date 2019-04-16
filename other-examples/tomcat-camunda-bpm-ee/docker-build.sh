#!/bin/sh
export $(cat camunda-enterprise-login.env | xargs)
docker build --build-arg EE_USERNAME="${EE_USERNAME}" --build-arg EE_PASSWORD="${EE_PASSWORD}" .
