#use base image as php
FROM php:7.4-apache

# main dir in the container
WORKDIR /var/www/html

# Copy the PHP code to the container
COPY index.php /var/www/html

# Install mysqli extension
RUN docker-php-ext-install mysqli

# Enable Apache rewrite module
RUN a2enmod rewrite

# Update Apache configuration to use .htaccess files
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Start the Apache web server
CMD ["apache2-foreground"]
