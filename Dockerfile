FROM alpine:3.9

RUN adduser -D --uid 1001 -g 'moodle' moodle && mkdir -p /home/moodle/www/ead2 && chown -R moodle:moodle /home/moodle/www/ead2

# Install packages
RUN apk --no-cache add php7 php7-fpm php7-mysqli php7-json php7-openssl php7-curl \
    php7-zlib php7-xml php7-phar php7-intl php7-dom php7-xmlreader php7-ctype \
    php7-mbstring php7-gd php7-iconv php7-zip php7-pear php7-memcached php7-redis \
    php7-pgsql php7-pspell php7-pdo_dblib php7-xmlrpc php7-opcache php7-imagick \
    php7-simplexml php7-fileinfo php7-tokenizer php7-soap php7-apcu nginx supervisor \
    curl zip unzip gzip unrar postfix htop bash git vim && chown -R moodle:moodle /var/tmp/nginx

# Install Zend with PEAR
RUN pear channel-discover pear.dotkernel.com/zf1/svn && pear install zend/zend

# Configure nginx
COPY config/nginx-ead2.conf /etc/nginx/nginx.conf

#Configure postfix relay
COPY config/postfix-main.cf /etc/postfix/main.cf

#Configure freetds
COPY config/freetds.conf /etc/freetds.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/zzz_custom.conf
COPY config/php.ini /etc/php7/conf.d/zzz_custom.ini
COPY config/www.conf /etc/php7/php-fpm.d/www.conf

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /home/moodle/www/ead2

EXPOSE 80
#EXPOSE 80 443
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
