FROM composer:2 AS composer-builder

WORKDIR /app

COPY . /app

RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist

FROM node:20-alpine AS node-builder

WORKDIR /app

COPY --from=composer-builder /app /app

RUN npm install

RUN npm run build

FROM dunglas/frankenphp:latest

WORKDIR /app

COPY --from=node-builder /app /app

RUN install-php-extensions pcntl pdo_mysql redis opcache

RUN php artisan config:cache && php artisan route:cache && php artisan view:cache

ENTRYPOINT ["php", "artisan", "octane:frankenphp"]

EXPOSE 8000
