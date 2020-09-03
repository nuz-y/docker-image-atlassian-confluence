[![Docker Stars](https://img.shields.io/docker/stars/eugenmayer/confluence.svg)](https://hub.docker.com/r/EugenMayer/confluence/) [![Docker Pulls](https://img.shields.io/docker/pulls/eugenmayer/confluence.svg)](https://hub.docker.com/r/eugenmayer/confluence/)

# Docker images for Atlassian Confluence

Production ready, up to date builds of Atlassian Confluence - right from the original binary download based on

  - adoptjdk openjdk 11 (Confluence 7) 
  - adoptjdk openjdk 8 (Confluence 6)

This project is build by concourse.ci, see [our oss pipelines here](https://github.com/EugenMayer/concourse-our-open-pipelines)

## Supported tags and respective Dockerfile links

| Product |Version | Tags  | Dockerfile |
|---------|--------|-------|------------|
| Confluence 7.x (adopt openjdk java11) | 5.7.x-7.x(latest) | [see tags](https://hub.docker.com/r/eugenmayer/confluence/tags/) | [Dockerfile](https://github.com/EugenMayer/docker-image-atlassian-confluence/blob/master/Dockerfile) |
| Confluence 6.13.x+ (adopt openjdk java8) | 6.13.x<7.x(latest) | [see tags](https://hub.docker.com/r/eugenmayer/confluence/tags/) | [Dockerfile_java8](https://github.com/EugenMayer/docker-image-atlassian-confluence/blob/master/Dockerfile_java8) |

## Related Images

You may also like:

* [jira](https://github.com/EugenMayer/docker-image-atlassian-jira)
* [bitbucket](https://github.com/EugenMayer/docker-image-atlassian-bitbucket)
* [rancher catalog - corresponding catalog for confluence](https://github.com/EugenMayer/docker-rancher-extra-catalogs/tree/master/templates/confluence)
* [development - running this image for development with debugging](https://github.com/EugenMayer/docker-image-atlassian-confluence/tree/master/examples/debug)

# In short

```git
docker-compose up
```

## Configuration

Please see the `docker-compose.yml` for the configuration variables

Also see the folder `examples/` for different examples

# Build The Image

Build image with the curent Confluence release:

```
docker-compose build confluence
```

If you want to build a specific release, just replace the version in .env and again run

```
docker-compose build confluence
```

# Environment variables

Configures the db host to wait for the DB to come up. Those variables are not used by confluence during the installation
- CONFLUENCE_DB_HOST=db 
- CONFLUENCE_DB_PORT=5432

Set the DEBUG port, e.g. for development
- JPDA_ADDRESS=5005
- JPDA_TRANSPORT=dt_socket

Configuratoin
- CATALINA_OPTS=-Xms256m -Xmx1g
- CONFLUENCE_PROXY_NAME=
- CONFLUENCE_PROXY_PORT=
- CONFLUENCE_PROXY_SCHEME=
- CONFLUENCE_DELAYED_START= # seconds to wait before starting confluence

# Volumes for persistence

You will need to persist 
  - the confluence data under `/var/atlassian/confluence`
  - the database folder postgres: `/var/lib/postgresql/data` or mysql: `/var/lib/mysql`
