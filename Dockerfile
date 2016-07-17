FROM mrskensington/docker-php-with-ext:7-fpm
MAINTAINER docker@mikeditum.co.uk

RUN apt-get update && \
    apt-get install -y wget supervisor sudo mysql-client && \
        apt-get clean

RUN mkdir -p /code && \
    cd /code && \
    wget -O tt-rss.tar.gz https://tt-rss.org/gitlab/fox/tt-rss/repository/archive.tar.gz && \
    tar xvf tt-rss.tar.gz && \
    mv tt-rss.git tt-rss && \
    rm -f tt-rss.tar.gz && \
    chown -R www-data:www-data tt-rss

ENV DB_TYPE=mysql \
    DB_HOST="" \
    DB_USER="" \
    DB_NAME="" \
    DB_PASS="" \
    DB_PORT=3306 \
    URL_PATH="" \
    ALLOW_REGISTRATION="false" \
    NEW_USER_EMAIL="user@your.domain.dom" \
    PLUGIN_LIST="auth_internal, note"

COPY config.php.tmpl /code/tt-rss/

COPY init_container.sh /usr/bin/

COPY ttrss-update.conf /etc/supervisor/conf.d/

RUN chmod +x /usr/bin/init_container.sh

VOLUME [ "/code/tt-rss" ]

ENTRYPOINT [ "/usr/bin/init_container.sh" ]
