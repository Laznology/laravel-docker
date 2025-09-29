FROM node:18-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

RUN npm run build

FROM composer:2 AS composer-build

WORKDIR /app

COPY --from=build /app /app

RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist

FROM dunglas/frankenphp:latest

WORKDIR /app

COPY --from=build /app/public /app/public
COPY --from=composer-build /app /app

RUN install-php-extensions pcntl pdo_mysql redis opcache

RUN php artisan config:cache && php artisan route:cache && php artisan view:cache

ENTRYPOINT ["php", "artisan", "octane:frankenphp"]

EXPOSE 8000
