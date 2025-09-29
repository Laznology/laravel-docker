FROM composer:2 AS build

WORKDIR /app

COPY . /app

RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist

FROM dunglas/frankenphp:latest

WORKDIR /app

COPY --from=build /app /app

RUN install-php-extensions pcntl pdo_mysql redis

RUN php artisan config:cache && php artisan route:cache && php artisan view:cache

ENTRYPOINT ["php", "artisan", "octane:frankenphp"]

EXPOSE 8000
