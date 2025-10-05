# Production-grade Dockerfile for PHP + Apache
# Use official PHP Apache image
FROM php:8.2-apache

# Enable Apache modules
RUN a2enmod rewrite headers remoteip

# Trust common private ranges (Traefik sits in front on Coolify)
RUN printf '%s\n' \
  'RemoteIPHeader X-Forwarded-For' \
  'RemoteIPTrustedProxy 10.0.0.0/8' \
  'RemoteIPTrustedProxy 172.16.0.0/12' \
  'RemoteIPTrustedProxy 192.168.0.0/16' \
  'RemoteIPTrustedProxy 127.0.0.1/32' \
  > /etc/apache2/conf-available/remoteip.conf && a2enconf remoteip

# Install PHP extensions and deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpng-dev libjpeg62-turbo-dev libfreetype6-dev \
    libonig-dev libzip-dev libicu-dev zlib1g-dev libxml2-dev \
    libcurl4-openssl-dev unzip git cron curl \
 && docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install -j"$(nproc)" gd intl mbstring zip mysqli pdo_mysql \
 && rm -rf /var/lib/apt/lists/*

# PHP and Apache config
COPY docker/php.ini /usr/local/etc/php/php.ini
COPY docker/vhost.conf /etc/apache2/sites-available/000-default.conf

# App code
WORKDIR /var/www/html
COPY . /var/www/html

# Permissions (adjust to your needs)
RUN chown -R www-data:www-data /var/www/html \
 && find /var/www/html -type d -exec chmod 755 {} \; \
 && find /var/www/html -type f -exec chmod 644 {} \;

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --retries=5 \
  CMD curl -fsS http://localhost/ || exit 1

CMD ["apache2-foreground"]
