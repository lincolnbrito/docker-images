FROM php:7.2-fpm

LABEL maintainer="Lincoln Brito <lincoln.sbrito@gmail.com>"
LABEL description="PHP 7.2 fpm"

RUN requirements="libmcrypt-dev g++ libicu-dev curl zip unzip supervisor sqlite3" \
    && apt-get update && apt-get install -y $requirements && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install intl \
    #
    && docker-php-install sqlite3 \
    && docker-php-install gd \
    && docker-php-install curl \
    && docker-php-install memcached \
    && docker-php-install imap \
    && docker-php-install xml \
    && docker-php-install zip \
    && docker-php-install bcmath \
    && docker-php-install soap \
    && docker-php-install readline \
    && docker-php-install xdebug \
    && docker-php-install msgpack \
    && docker-php-install igbinary \
    #
    && requirementsToRemove="g++" \
    && apt-get purge --auto-remove -y $requirementsToRemove

RUN sed -i -e 's/listen.*/listen = 0.0.0.0:9000/' /usr/local/etc/php-fpm.conf

RUN usermod -u 1000 www-data

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["php-fpm"]