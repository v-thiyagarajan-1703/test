# Use the official PHP 8.3 image as the base image
FROM php:8.3-apache

# Set the working directory inside the container
WORKDIR /var/www/html

# Install system dependencies, PHP extensions, and cron
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    cron \
    && docker-php-ext-install mysqli pdo_mysql mbstring exif pcntl bcmath gd \
    # Clean up unnecessary files to reduce image size
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache modules and configure the server
RUN a2enmod rewrite \
    && a2enmod headers \
    && a2enmod ssl \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Copy the application files
COPY . .

# Set proper permissions for files
RUN chown -R www-data:www-data /var/www/html

# Copy the cron job file
COPY crontab /etc/cron.d/my-cron

# Set permissions and register the cron job
RUN chmod 0644 /etc/cron.d/my-cron && crontab /etc/cron.d/my-cron

# Ensure cron log file exists
RUN touch /var/log/cron.log

# Expose port 80
EXPOSE 80

# Start Cron and Apache together
CMD cron -f & apache2-foreground
