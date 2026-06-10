FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    libicu-dev libxml2-dev libzip-dev libpng-dev \
    libpq-dev unzip curl \
    && docker-php-ext-install intl xml zip gd pdo pdo_mysql mysqli soap opcache exif \
    && a2enmod rewrite \
    && rm -rf /var/lib/apt/lists/*

RUN printf "upload_max_filesize=512M\npost_max_size=512M\nmax_execution_time=360\nmax_input_vars=5000\nmemory_limit=256M\n" > /usr/local/etc/php/conf.d/moodle.ini

RUN mkdir -p /var/moodledata && chmod 777 /var/moodledata

RUN curl -L "https://download.moodle.org/download.php/direct/stable405/moodle-latest-405.tgz" \
    -o /tmp/moodle.tgz \
    && tar -xzf /tmp/moodle.tgz -C /var/www/html --strip-components=1 \
    && chown -R www-data:www-data /var/www/html /var/moodledata \
    && rm /tmp/moodle.tgz

RUN printf "<VirtualHost *:80>\n    DocumentRoot /var/www/html\n    <Directory /var/www/html>\n        Options Indexes FollowSymLinks\n        AllowOverride All\n        Require all granted\n    </Directory>\n</VirtualHost>\n" > /etc/apache2/sites-available/000-default.conf

EXPOSE 80
