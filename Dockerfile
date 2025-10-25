# Use PHP 8.3 with Apache
FROM php:8.3-apache

# Install system dependencies & PostgreSQL driver
RUN apt-get update && apt-get install -y \
    libpq-dev \
    zip \
    unzip \
    git \
    curl \
    && docker-php-ext-install pdo pdo_pgsql pgsql

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install Composer globally
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy project files
COPY . .

# Set Apache DocumentRoot to Laravel public folder
RUN sed -i 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

# (Optional) clear cached config safely
RUN php artisan optimize:clear || true

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
