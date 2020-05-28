#!/bin/bash

sudo docker stop nginx-php56; sudo docker rm nginx-php56

sudo docker run --name nginx-php56 \
  -v "$PWD"/conf:/etc/nginx/sites-available \
  -v "$PWD"/moodledata:/moodledata:rw \
  -v "$PWD"/www:/var/www:rw \
  -p 1081:80 \
  -d php56-nginx /sbin/my_init
