#!/bin/bash
set -e

echo 'Esperando base de datos...'
until php -r "new PDO('mysql:host=mariadb;port=3306;dbname=moodle', 'moodle', 'moodlepass123');" 2>/dev/null; do
    sleep 3
done
echo 'Base de datos lista.'

if [ ! -f /var/www/html/config.php ]; then
    echo 'Instalando Moodle por primera vez (~5 min)...'
    php /var/www/html/admin/cli/install.php \
        --chmod=2777 \
        --lang=es \
        --wwwroot=http://localhost:8080 \
        --dataroot=/var/moodledata \
        --dbtype=mariadb \
        --dbhost=mariadb \
        --dbname=moodle \
        --dbuser=moodle \
        --dbpass=moodlepass123 \
        --fullname='Plataforma HCVB' \
        --shortname=HCVB \
        --adminuser=admin \
        --adminpass=Admin1234! \
        --adminemail=admin@hcvb.cl \
        --agree-license \
        --non-interactive
    echo 'Moodle instalado exitosamente!'
fi

exec "$@"
