FROM symfony4-7.3-fpm-alpine3.8:latest

ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL

LABEL build-date=$BUILD_DATE \
      name="nginx-symfony4-7.3-fpm-alpine3.8" \
      description="Nginx with Symfony 4 PHP 7.3 Alpine" \
      usage="" \
      vcs-ref=$VCS_REF \
      vcs-url=$VCS_URL \
      vendor="" \
      version='' \
      schema-version="1.0"

USER root

# Install Nginx and needed tools
RUN apk add --no-cache nginx sed git wget tini libcap && \
    chown -R www:www /run/ /tmp/ /etc/nginx/ /var/lib/nginx/ /var/log/nginx && \
    setcap 'cap_net_bind_service=+ep' /usr/sbin/nginx

COPY --chown=www:www . /tmp/

# Nginx config
RUN mv /tmp/nginx.conf /etc/nginx/ && \
    sed -i 's/404/200/g' /etc/nginx/conf.d/default.conf && \
    mv /tmp/run.sh /run.sh

USER www

HEALTHCHECK CMD curl --fail http://127.0.0.1:80/ || exit 1

EXPOSE 80

STOPSIGNAL SIGQUIT

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/run.sh"]