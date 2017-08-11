## Docker image using official Tomcat and adding Camunda

First create a db container with the db of your choice (here MySQL - which does not mean in any way that we recommend MySQL over other databases)
```shell
docker run --name mysql -e MYSQL_ROOT_PASSWORD=password -e MYSQL_USER=user -e MYSQL_PASSWORD=password -e MYSQL_DATABASE=camunda -d mysql:latest
```

Then build the image from Dockerfile
```shell
docker build -t my-camunda .
```

Last run the tomcat container
```shell
docker run -d -p 8080:8080 --env-file ./.docker-env --name app --link mysql:db my-camunda
```


.docker-env-file content
```
TOMCAT_USER=admin
TOMCAT_PASS=admin
DB_USERNAME=user
DB_PASSWORD=password
DB_DRIVER=com.mysql.jdbc.Driver
DB_URL=jdbc:mysql://db:3306/camunda
``` 

Driver class name and URL can be easily looked up for your project. 

login
```shell
docker exec -it my-camunda bash
cd ${CATALINA_HOME}
```

Open in browser: 

* [Camunda Webapp](http://localhost:8080/camunda/)
* [Tomcat Manager](http://localhost:8080/manager/html)
