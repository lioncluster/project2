# Specify the the image of worpresse you will use
FROM wordpress:latest
# describe the maintener of this file
LABEL description="This file contains set of command to install Wordpress"
LABEL maintainer="Lion Cluster"
# Add the database credentials
ENV WORDPRESS_DB_HOST=mysqldb.cwy2x3cevbra.us-east-1.rds.amazonaws.com:3306 \
    WORDPRESS_DB_USER=admin \
    WORDPRESS_DB_PASSWORD=lion2023 \
    WORDPRESS_DB_NAME=NASFinancialDB
# Install necessary packages and dependencies
RUN apt-get update && apt-get install -y \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
        libzip-dev \
        zip \
        unzip \
        && docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
        && docker-php-ext-install -j$(nproc) \
        gd \
        mysqli \
        zip
# Copy custom Apache configuration
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf
# Enable Apache mod_rewrite
RUN a2enmod rewrite
# Expose ports and define volume
EXPOSE 80
EXPOSE 443
VOLUME ./:/var/www/html
# Set the entrypoint
ENTRYPOINT ["docker-entrypoint.sh"]
# Set the default command
CMD ["apache2-foreground"]