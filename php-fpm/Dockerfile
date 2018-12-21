FROM php:7.3-fpm-alpine3.8

ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL
ARG TZ='Europe/Warsaw'

LABEL build-date=$BUILD_DATE \
      name="symfony4-7.3-fpm-alpine3.8" \
      description="Symfony 4 PHP 7.3 Alpine" \
      usage="" \
      vcs-ref=$VCS_REF \
      vcs-url=$VCS_URL \
      vendor="" \
      version='7.3' \
      schema-version="1.0"


RUN addgroup -g 1000 www && \
    adduser -D -u 1000 -G www -h /var/www www

# common packages
RUN apk add --no-cache \
    curl \
    git \
    grep \
    tini

# php requiments
# tzdata
RUN apk add --no-cache --virtual .build-deps tzdata && \
    cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apk del .build-deps

RUN apk add --no-cache \
    zip \
    libzip \
    openssh-client \
    openssl
    
# build packages
RUN apk add --no-cache --virtual .build-deps \
    autoconf \
    libzip-dev \
    $PHPIZE_DEPS \
    openssl-dev

# php extensions
RUN pecl install mongodb-1.5.3 && docker-php-ext-enable mongodb && \
    pecl install redis-4.2.0 && docker-php-ext-enable redis && \
    docker-php-ext-configure zip --with-libzip && docker-php-ext-install zip && \
    docker-php-ext-install \
        iconv \
        bcmath

# clear build packages
RUN apk del .build-deps && \
    rm -rf /tmp/pear

COPY --chown=www:www conf/ /tmp/
RUN mv /tmp/php.ini /usr/local/etc/php/ && \
    mv /tmp/opcache.ini /usr/local/etc/php/conf.d/ && \
    mv /tmp/www.conf /usr/local/etc/php-fpm.d/ && \
    mv /tmp/test.sh /test.sh && \
    chmod +x /test.sh && \
    rm -rf /tmp/* /var/www/html/ && \
    sed -i '/access/d' /usr/local/etc/php-fpm.d/docker.conf && \
    chown -R www:www /usr/local/etc/php

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=1.6.5

USER www

WORKDIR /var/www

HEALTHCHECK --interval=10s --timeout=3s \
    CMD \
    SCRIPT_NAME=/ping \
    SCRIPT_FILENAME=/ping \
    REQUEST_METHOD=GET \
    cgi-fcgi -bind -connect 127.0.0.1:9000 || exit 1

EXPOSE 9000

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["php-fpm"]
