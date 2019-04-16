# Example Dockerfile for Camunda on Tomcat

This docker image is based on the official Docker image for the Camunda Enterprise Edition and hardens it for production use by removing examples and enabling security features.

![Docker Tomcat Camunda BPM](docker-tomcat-camunda-bpm.png)

Build the image from Dockerfile

```shell
docker login registry.camunda.cloud
docker build --tag my-camunda-tomcat .
```

Run the Tomcat container

```shell
docker run -p 8080:8080 my-camunda-tomcat
```

Open in browser: 

* [Camunda Webapp](http://localhost:8080/camunda/)


For available configuration options have a look on the [Documentation of the official Camunda Docker images](https://github.com/camunda/docker-camunda-bpm-platform/tree/master#database-environment-variables).

