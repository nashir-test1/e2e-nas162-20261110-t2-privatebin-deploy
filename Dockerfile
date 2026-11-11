FROM php:8.5-apache
WORKDIR /var/www/html
COPY . .
COPY deploy/apache.conf /etc/apache2/sites-available/000-default.conf
RUN sed -i 's/^Listen 80$/Listen 8080/' /etc/apache2/ports.conf \
    && mkdir -p data \
    && chown -R www-data:www-data data \
    && php -r 'exit(extension_loaded("zlib") ? 0 : 1);'
ENV APACHE_RUN_DIR=/tmp/apache2 \
    APACHE_PID_FILE=/tmp/apache2/apache2.pid \
    APACHE_LOCK_DIR=/tmp/apache2-lock \
    APACHE_LOG_DIR=/tmp/apache2-log
USER www-data
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=5s CMD php -r 'exit(@file_get_contents("http://127.0.0.1:8080/") === false ? 1 : 0);'
CMD ["apache2-foreground"]
