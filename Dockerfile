# Use PHP 8.2
FROM php:8.2-cli

# Install required PHP extensions
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-install zip

# Set working directory
WORKDIR /app

# Copy application files
COPY . /app/

# Set proper permissions
RUN chmod -R 755 /app

# Expose port 3000
EXPOSE 3000

# Start PHP built-in server
CMD ["php", "-S", "0.0.0.0:3000", "-t", "/app"]

