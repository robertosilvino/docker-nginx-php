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
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y php7.0 php7.0-cli php7.0-fpm php7.0-mysql \
 php7.0-curl php7.0-gd php7.0-mcrypt php7.0-intl php7.0-imap php7.0-tidy php7.0-xml php7.0-xmlrpc php7.0-dom \
 php7.0-zip php7.0-soap php7.0-mbstring php7.0-pspell php7.0-recode php7.0-sqlite3 php7.0-xsl
# php-xdebug

RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y freetds-bin php7.0-sybase php7.0-dev php-pear
## moodle3.0
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y ghostscript

## pear e zend framework
RUN pear channel-discover pear.dotkernel.com/zf1/svn && pear install zend/zend

RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php/7.0/fpm/php.ini
RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php/7.0/cli/php.ini

RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y nginx

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.0/fpm/php-fpm.conf
RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini

# Configure PHP-FPM
COPY .docker-config/fpm-pool.conf /etc/php/7.0/fpm/zzz_custom.conf
COPY .docker-config/php.ini /etc/php/7.0/fpm/conf.d/zzz_custom.ini
COPY .docker-config/www.conf /etc/php/7.0/fpm/conf.d/www.conf

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
