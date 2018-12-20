# Running
docker build -t symfony4-7.3-fpm-alpine3.8 ./php-fpm/
docker run --rm symfony4-7.3-fpm-alpine3.8:latest sh /test.sh

# composer
composer create-project symfony/website-skeleton app