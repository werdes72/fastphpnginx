FROM php:7.3-fpm-buster

RUN set -x \
        && addgroup --system --gid 101 nginx \
        && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent \
                --gecos "nginx user" --shell /bin/false --uid 101 nginx \
        && apt-get update \
        && apt-get install -y --no-install-recommends --no-install-suggests \
                libicu-dev zlib1g-dev libzip-dev libpng-dev librabbitmq-dev default-mysql-client unzip git ssh nginx \
                jpegoptim optipng pngquant gifsicle libmagickwand-dev \
        && docker-php-ext-configure intl \
        && docker-php-ext-configure calendar \
        && docker-php-ext-install intl zip gd bcmath sockets pdo_mysql calendar opcache mysqli \
        && pecl install -o -f redis && rm -rf /tmp/pear \
        && pecl install mongodb amqp imagick && docker-php-ext-enable mongodb amqp imagick redis \
        && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
        && composer global require hirak/prestissimo brianium/paratest \
        && mkdir ~/.ssh/ && echo "Host bitbucket.org\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config \
        && apt-get purge -y --auto-remove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* || true

EXPOSE 80 9000
WORKDIR /var/www
