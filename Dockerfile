FROM dunglas/frankenphp:latest

RUN install-php-extensions pcntl pdo_mysql redis

WORKDIR /app

COPY . /app

RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist

RUN php artisan config:cache && php artisan route:cache && php artisan view:cache

ENTRYPOINT ["php", "artisan", "octane:frankenphp"]

EXPOSE 8000
