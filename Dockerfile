# Use Ubuntu as the base image
FROM ubuntu

# Install Apache2 and other dependencies
RUN apt-get update && \
apt-get install -y apache2 && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

# Copy custom HTML file to Apache document root
COPY index.html /var/www/html/

# Expose port 80 for Apache
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2ctl", "-D", "FOREGROUND"]
