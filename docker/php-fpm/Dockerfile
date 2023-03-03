FROM phpdockerio/php:8.1-fpm

RUN apt-get update \
    && apt-get -y --no-install-recommends install php8.1-memcached php8.1-mysql php8.1-sqlite3 php8.1-xdebug php8.1-mongodb php8.1-intl php8.1-gd php8.1-redis mysql-client \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN touch /run/php-fpm.pid \
    && groupadd -g 1000 www \
    && useradd -u 1000 -ms /bin/bash -g www www \
    && chown www:www /run/php-fpm.pid

USER www

