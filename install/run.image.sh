#!/bin/bash

sudo docker stop docker-nginx-php70; sudo docker rm docker-nginx-php70

sudo docker run --name docker-nginx-php70 \
  -v "$PWD"/../conf:/etc/nginx/sites-available \
  -v "$PWD"/../moodledata:/var/moodledata:rw \
  -v "$PWD"/../www:/var/www:rw \
  -p 1080:80 \
  -p 10443:443 \
  -d docker-php70-nginx /sbin/my_init \
  --enable-insecure-key
