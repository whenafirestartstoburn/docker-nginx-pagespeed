# Lightweight Docker Image include Nginx with PageSpeed and GEO IP module
 
This docker image based on [Alpine](https://hub.docker.com/_/alpine/). 
Alpine is based on [Alpine Linux](http://www.alpinelinux.org), lightweight Linux distribution based on [BusyBox](https://hub.docker.com/_/busybox/). 

The goal is to create a small docker Nginx image size, that is purposed to run a cluster of vhosts sites with different PHP engine versions.

I personally use it with distributed, orchestrated hosting deployments, therefore environment file contains variables for orchestrator API endpoint.

JSON payload is beging pulled from specified remote API endpoint in format of:

```json
{ 
    'domain1.com': 'nginx configuration template',
    'domain2.com': 'nginx configuration template',
}
```

to be parsed into individual vhosts configuration files injected into: 
/etc/nginx/config.d/ folder on container boot.

## PageSpeed
The [PageSpeed](https://developers.google.com/speed/pagespeed/) tools analyze and optimize your site following web best practices.

## Supported tags and `Dockerfile` links

 - [`1.13.0`, `latest` (Dockerfile)](https://github.com/lagun4ik/docker-nginx-pagespeed/blob/master/Dockerfile)
 - [`1.11.13` (Dockerfile)](https://github.com/lagun4ik/docker-nginx-pagespeed/blob/1.11.13/Dockerfile)

## Credits to original project

This image is published in the [Docker Hub](https://hub.docker.com/r/lagun4ik/nginx-pagespeed/) as `lagun4ik/nginx-pagespeed`

## Configuration

The config is set using environments
```docker
# default values
PAGESPEED_ENABLE=on # || off
```

## Example compose file

```yaml
version: '2'

services:
  nginx:
    image: crunchgeek/nginx-pagespeed
    restart: always
    ports:
      - "80:80"
    hostname: ${HOST_NAME}-nginx
    container_name: nginx
    volumes:
      - ${APPLICATIONS}:/applications:ro
      - ./HEALTHCHECK:/var/www/HEALTHCHECK:ro

```
