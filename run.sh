#!/bin/bash
sudo docker stop nginx-php72; sudo docker rm nginx-php72

sudo docker run --name nginx-php72 \
  -v /home/moodle/moodledata/ead2:/home/moodle/moodledata/ead2:rw \
  -v /home/moodle/www/ead2:/home/moodle/www/ead2:rw \
  -v /var/moodledata_temporarios/ead2:/var/moodledata_temporarios/ead2:rw \
  -p 1082:80 \
  -d php72-nginx

#  -v /home/moodle/moodledata:/home/moodle/moodledata:rw \
#  -v /home/moodle/www:/home/moodle/www:rw \
#  -v "$PWD"/conf:/etc/nginx/sites-available \
#  -v "$PWD"/moodledata:/moodledata:rw \
#  -v "$PWD"/www:/var/www:rw \
