FROM phusion/baseimage:0.11

# Ensure UTF-8
RUN locale-gen pt_BR.UTF-8
ENV LANG       pt_BR.UTF-8
ENV LC_ALL     pt_BR.UTF-8

ENV HOME /root

RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

CMD ["/sbin/my_init"]

# Nginx-PHP Installation
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y vim curl wget build-essential software-properties-common
RUN add-apt-repository -y ppa:ondrej/php
RUN add-apt-repository -y ppa:nginx/stable
#RUN apt-get update
RUN apt-get update --fix-missing
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y --allow-remove-essential php7.2 php7.2-cli php7.2-fpm php7.2-mysql \
 php7.2-curl php7.2-gd php7.2-intl php7.2-imap php7.2-tidy php-xml php7.0-xml php7.0-xmlrpc php7.2-dom php7.2-zip \
 php7.2-soap php7.2-mbstring php7.2-pspell php7.2-recode php7.2-sqlite3 php7.2-xsl
# php-xdebug

# Pear issue
RUN mkdir -p /tmp/pear/cache

RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y --allow-remove-essential php7.2-dev libmcrypt-dev php-pear \
    libc-dev pkg-config libmcrypt-dev
RUN DEBIAN_FRONTEND="noninteractive" pecl channel-update pecl.php.net
RUN DEBIAN_FRONTEND="noninteractive" pecl install mcrypt-1.0.1
#RUN DEBIAN_FRONTEND="noninteractive" pecl install mcrypt-1.0.2

RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y freetds-bin php7.2-sybase

RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php/7.2/fpm/php.ini
RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php/7.2/cli/php.ini

RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y nginx

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.2/fpm/php-fpm.conf
RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.2/fpm/php.ini

# Configure PHP-FPM
COPY .docker-config/fpm-pool.conf /etc/php/7.2/fpm/zzz_custom.conf
COPY .docker-config/php.ini /etc/php/7.2/fpm/conf.d/zzz_custom.ini
COPY .docker-config/www.conf /etc/php/7.2/fpm/conf.d/www.conf

RUN mkdir           /etc/service/nginx
ADD build/nginx.sh  /etc/service/nginx/run
RUN chmod +x        /etc/service/nginx/run
RUN mkdir           /etc/service/phpfpm
ADD build/phpfpm.sh /etc/service/phpfpm/run
RUN chmod +x        /etc/service/phpfpm/run

RUN chown -R :www-data /var/www && \
    mkdir -p /moodledata && \
    chown -R :www-data /moodledata

RUN rm -rf .docker-config/

EXPOSE 80
# End Nginx-PHP

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
