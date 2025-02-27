# Use the official PHP image with Apache
FROM php:apache

# Install necessary packages including cron
RUN apt-get update && apt-get install -y \
    unzip \
    curl \
    cron \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /var/www/html

# Download and extract the GitHub repo
RUN curl -L https://github.com/v-thiyagarajan-1703/test/archive/refs/heads/main.zip -o repo.zip \
    && unzip repo.zip \
    && mv test-main/* . \
    && rm -rf test-main repo.zip

# Set file permissions
RUN chown -R www-data:www-data /var/www/html

# Add cron jobs directly to crontab
RUN echo "* * * * * /usr/local/bin/php /var/www/html/cron.php >> /var/www/html/cron_output.txt 2>&1" | crontab -

# Create the log file
RUN touch /var/www/html/cron_output.txt && chown www-data:www-data /var/www/html/cron_output.txt

# Start cron correctly inside Docker
CMD ["bash", "-c", "cron && apache2-foreground"]

