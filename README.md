[![Docker Stars](https://img.shields.io/docker/stars/eugenmayer/confluence.svg)](https://hub.docker.com/r/EugenMayer/confluence/) [![Docker Pulls](https://img.shields.io/docker/pulls/eugenmayer/confluence.svg)](https://hub.docker.com/r/eugenmayer/confluence/)


# Atlassian Confluence the Docker way

"One place for all your team's work - Spend less time hunting things down and more time making things happen. Organize your work, create documents, and discuss everything in one place." - [[Source](https://www.atlassian.com/software/confluence)]

## Supported tags and respective Dockerfile links

| Product |Version | Tags  | Dockerfile |
|---------|--------|-------|------------|
| Confluence | 5.7.x-6.x(latest) | [see tags](https://hub.docker.com/r/eugenmayer/confluence/tags/) | [Dockerfile](https://github.com/EugenMayer/docker-image-atlassian-confluence/blob/master/Dockerfile) |

## Related Images

You may also like:

* [jira](https://github.com/EugenMayer/docker-image-atlassian-jira)

# Make It Short

~~~~
docker-compose up
~~~~

# Setup

1. Start the database container
2. Start Confluence
3. Setup Confluence

First start the database server:

> Note: Change Password!

~~~~
docker run --name postgres -d \
    -e 'POSTGRES_USER=jira' \
    -e 'POSTGRES_PASSWORD=jellyfish' \
    -e 'POSTGRES_ENCODING=UTF8' \
    -e 'POSTGRES_COLLATE=C' \
    -e 'POSTGRES_COLLATE_TYPE=C' \
    blacklabelops/postgres
~~~~

> This is the blacklabelops postgres image.

Secondly start Confluence with a link to postgres:

~~~~
docker run -d --name confluence \
	  --link postgres:postgres \
	  -p 80:8090 -p 8091:8091 docker-image-atlassian-confluence
~~~~

>  Start the Confluence and link it to the postgresql instance.

Thirdly, configure your Confluence yourself and fill it with a test license.

1. Choose `Production Installation` because we have a postgres!
2. Enter license information
3. In `Choose a Database Configuration` choose `PostgeSQL` and press `External Database`
4. In `Configure Database` press `Direct JDBC`
5. In `Configure Database` fill out the form:

* Driver Class Name: `org.postgresql.Driver`
* Database URL: `jdbc:postgresql://postgres:5432/confluencedb`
* User Name: `confluencedb`
* Password: `jellyfish`

> Note: Change Password!

## PostgreSQL

Let's take an PostgreSQL Docker Image and set it up:

Postgres Official Docker Image:

~~~~
docker run --name postgres -d \
    -e 'POSTGRES_DB=confluencedb' \
    -e 'POSTGRES_USER=confluencedb' \
    -e 'POSTGRES_PASSWORD=jellyfish' \
    postgres:9.4
~~~~

> This is the official postgres image.

Postgres Community Docker Image:

~~~~
docker run --name postgres -d \
    -e 'DB_USER=confluencedb' \
    -e 'DB_PASS=jellyfish' \
    -e 'DB_NAME=confluencedb' \
    sameersbn/postgresql:9.4-12
~~~~

> This is the sameersbn/postgresql docker container I tested.

Now start the Confluence container and let it use the container. On first startup you have to configure your Confluence yourself and fill it with a test license.

1. Choose `Production Installation` because we have a postgres!
2. Enter license information
3. In `Choose a Database Configuration` choose `PostgeSQL` and press `External Database`
4. In `Configure Database` press `Direct JDBC`
5. In `Configure Database` fill out the form:

* Driver Class Name: `org.postgresql.Driver`
* Database URL: `jdbc:postgresql://postgres:5432/confluencedb`
* User Name: `confluencedb`
* Password: `jellyfish`

~~~~
docker run -d --name confluence \
	  --link postgres:postgres \
	  -p 80:8090 -p 8091:8091 docker-image-atlassian-confluence
~~~~

>  Start the Confluence and link it to the postgresql instance.

## MySQL

Let's take an MySQL container and set it up:

MySQL Official Docker Image:

~~~~
docker run -d --name mysql \
    -e 'MYSQL_ROOT_PASSWORD=verybigsecretrootpassword' \
    -e 'MYSQL_DATABASE=confluencedb' \
    -e 'MYSQL_USER=confluencedb' \
    -e 'MYSQL_PASSWORD=jellyfish' \
    mysql:5.6
~~~~

> This is the mysql docker container I tested.

MySQL Community Docker Image:

~~~~
docker run -d --name mysql \
    -e 'ON_CREATE_DB=confluencedb' \
    -e 'MYSQL_USER=confluencedb' \
    -e 'MYSQL_PASS=jellyfish' \
    tutum/mysql:5.6
~~~~

> This is the tutum/mysql docker container I tested.

Now start the Confluence container and let it use the container. On first startup you have to configure your Confluence yourself and fill it with a test license.

1. Choose `Production Installation` because we have a mysql!
2. Enter license information
3. In `Choose a Database Configuration` choose `MySQL` and press `External Database`
4. In `Configure Database` press `Direct JDBC`
5. In `Configure Database` fill out the form:

* Driver Class Name: `com.mysql.jdbc.Driver`
* Database URL: `jdbc:mysql://mysql/confluencedb?sessionVariables=storage_engine%3DInnoDB&useUnicode=true&characterEncoding=utf8`
* User Name: `confluencedb`
* Password: `jellyfish`

~~~~
docker run -d --name confluence \
	  --link mysql:mysql \
	  -p 80:8090 -p 8091:8091 docker-image-atlassian-confluence
~~~~

>  Start the Confluence and link it to the postgresql instance.

>  Start the Confluence and link it to the mysql instance.

> Confluence will be available at http://yourdockerhost

# Proxy Configuration

You can specify your proxy host and proxy port with the environment variables CONFLUENCE_PROXY_NAME and CONFLUENCE_PROXY_PORT. The value will be set inside the Atlassian server.xml at startup!

When you use https then you also have to include the environment variable CONFLUENCE_PROXY_SCHEME.

Example HTTPS:

* Proxy Name: myhost.example.com
* Proxy Port: 443
* Poxy Protocol Scheme: https

Just type:

~~~~
docker run -d --name confluence \
    -e "CONFLUENCE_PROXY_NAME=myhost.example.com" \
    -e "CONFLUENCE_PROXY_PORT=443" \
    -e "CONFLUENCE_PROXY_SCHEME=https" \
    docker-image-atlassian-confluence
~~~~

> Will set the values inside the server.xml in /opt/confluence/conf/server.xml

# Build The Image

Build image with the curent Confluence release:

```
docker-compose build confluence
```


If you want to build a specific release, just replace the version in .env and again run

```
docker-compose build confluence
```

# Container Permissions

Simply: You can set user-id and group-id matching to a user and group from your host machine!

Due to security considerations this image is not running in root mode! The Jenkins process user inside the container is `confluence` and the user's group is `confluence`. This project offers a simplified mechanism for user- and group-mapping. You can set the uid of the user and gid of the user's group during build time.

The process permissions are relevant when using volumes and mounted folders from the host machine. Confluence need read and write permissions on the host machine. You can set UID and GID of the Confluence's process during build time! UID and GID should resemble credentials from your host machine.

The following build arguments can be used:

* CONTAINER_UID: Set the user-id of the process. (default: 1000)
* CONTAINER_GID: Set the group-id of the process. (default: 1000)

Example:

~~~~
docker build --build-arg CONTAINER_UID=2000 --build-arg CONTAINER_GID=2000 -t docker-image-atlassian-confluence .
~~~~

> The container will write and read files with UID 2000 and GID 2000.

# A word about memory usage

Confluence like any Java application needs a huge amount of memory. If you limit the memory usage by using the Docker --mem option make sure that you give enough memory. Otherwise your Confluence will begin to restart randomly.
You should give at least 1-2GB more than the JVM maximum memory setting to your container.

# Contributions

I am happy to take on pull requests and suggestion, but will try to keep the image as dry as possible. 

# Credits

This repo and project is based on the great work of

[blacklabelops/confluence](https://bitbucket.org/blacklabelops/confluence)

## References
* [Atlassian Confluence](https://www.atlassian.com/software/confluence)
* [Docker Homepage](https://www.docker.com/)
* [Docker Compose](https://docs.docker.com/compose/)
* [Docker Userguide](https://docs.docker.com/userguide/)
* [Oracle Java](https://java.com/de/download/)
