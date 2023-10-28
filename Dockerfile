FROM php:8.1.0-apache
WORKDIR /var/www/html
COPY ./src/ /var/www/html/

# Mod Rewrite
RUN a2enmod rewrite

# Linux Library
RUN apt-get update -y && apt-get install -y \
libicu-dev \
unzip zip \
zlib1g-dev \
libpng-dev \
libjpeg-dev \
libfreetype6-dev \
libjpeg62-turbo-dev \
libpng-dev

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# PHP Extensions
RUN docker-php-ext-install gettext intl gd

RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg \
&& docker-php-ext-install -j$(nproc) gd

# Install Postgres PDO
RUN apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql