FROM codemix/yii2-base:2.0.12-php7-apache
#FROM codemix/yii2-base:2.0.12-php7-fpm
#FROM codemix/yii2-base:2.0.12-hhvm

RUN apt-get update \
        && apt-get -y install \
        git \
        g++ \
        libicu-dev \
        libmcrypt-dev \
        zlib1g-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libpq-dev \
        --no-install-recommends \
        && docker-php-ext-install pdo_pgsql \
        && docker-php-ext-install iconv mcrypt \
        && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
        && docker-php-ext-install gd

# Composer packages are installed first. This will only add packages
# that are not already in the yii2-base image.
COPY composer.json /var/www/html/
#COPY composer.lock /var/www/html/
RUN composer self-update --no-progress && \
    composer install --no-progress

# Copy the working dir to the image's web root
COPY . /var/www/html

# The following directories are .dockerignored to not pollute the docker images
# with local logs and published assets from development. So we need to create
# empty dirs and set right permissions inside the container.
RUN mkdir runtime web/assets \
    && chown www-data:www-data runtime web/assets

# Expose everything under /var/www (vendor + html)
# This is only required for the nginx setup
VOLUME ["/var/www"]
