#!/bin/bash

sudo docker stop docker-nginx-php56; sudo docker rm docker-nginx-php56

sudo docker run --name docker-nginx-php56 \
  -v "$PWD"/../conf:/etc/nginx/sites-available \
  -v "$PWD"/../moodledata:/var/moodledata:rw \
  -v "$PWD"/../www:/var/www:rw \
  -p 1080:80 \
  -p 10443:443 \
  -d docker-php56-nginx /sbin/my_init \
  --enable-insecure-key
