# PHP Docker image for Yii 2.0 Framework runtime
# ==============================================

ARG PHP_BASE_IMAGE_VERSION
FROM yiisoftware/yii2-php:${PHP_BASE_IMAGE_VERSION}-fpm

# Install system packages for PHP extensions recommended for Yii 2.0 Framework
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get -y install \
        gnupg2 && \
    apt-key update && \
    apt-get update && \
    apt-get -y install \
            git \
            nano \
            npm \
            default-mysql-client \
            nginx-full \
            cron \
            supervisor \
            procps \
        --no-install-recommends && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install less-compiler
RUN npm -g install \
        less \
        lesshint \
        uglify-js \
        uglifycss

# Install Yii framework bash autocompletion
RUN curl -L https://raw.githubusercontent.com/yiisoft/yii2/master/contrib/completion/bash/yii \
        -o /etc/bash_completion.d/yii

# Add configuration files
COPY image-files/ /

# Add GITHUB_API_TOKEN support for composer
RUN chmod 700 \
        /usr/local/bin/docker-entrypoint.sh \
        /usr/local/bin/docker-run.sh \
        /usr/local/bin/composer

WORKDIR /app

# Startup script for FPM
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log \
 && ln -sf /usr/sbin/cron /usr/sbin/crond

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]

EXPOSE 80 443