# Example Dockerfiles for Camunda

## Folder Structure
Folder/File | Description
---|---
./camunda-tomcat-hardened | Dockerfile for Camunda Tomcat distro incl. Tasklist and Cockpit 
./postgres-camunda-ee | Dockerfile for PostreSQL incl. Camunda tables and license 
docker-compose.yml | Docker composition that wires all services together

## Running

- Build and run all Docker images using `docker-compose up -d --build`
- View the logs using `docker-compose logs -f`
- Show down all containers and delete all volumes using `docker-compose down -v`

## URLs
- [Camunda Cockpit](http://localhost:8080/camunda/app/cockpit/default/) (username: demo, password: demo)
- jdbc:postgresql://localhost:5432/camunda (username: camunda, password: camunda)
