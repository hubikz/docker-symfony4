#!/usr/bin/env ash
set -x

php-fpm7 --daemonize;
exec nginx;
