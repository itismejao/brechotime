FROM php:8.1.5-fpm

ENV APP_ROOT=/home/app 
ENV QUEUE_DRIVER=database 
ENV OPTIONS=

RUN docker-php-ext-install pdo pdo_mysql

RUN apt-get update && apt-get install supervisor -y

RUN mkdir -p "/etc/supervisor/logs"

CMD ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisor/supervisord.conf"]