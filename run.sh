#!/bin/bash
sudo docker stop nginx-php70; sudo docker rm nginx-php70

sudo docker run --name nginx-php70 \
  -v "$PWD"/conf:/etc/nginx/sites-available \
  -v "$PWD"/moodledata:/moodledata:rw \
  -v "$PWD"/www:/var/www:rw \
  -p 1080:80 \
  -d php70-nginx /sbin/my_init
