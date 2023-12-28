# Use a imagem baseada em Debian com Apache
FROM php:8.1-apache-bookworm

# Atualize os pacotes do sistema operacional
RUN apt update && apt install -y \
    zip \
    unzip \
    libpq-dev \
    curl \
    npm \
    && rm -rf /var/cache/apk/* \
    && apt-get clean

# Instale as extensões PHP necessárias
RUN docker-php-ext-install \
    pdo \
    pdo_mysql \
    pdo_pgsql

# Configurando root para pasta public
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# mod_rewrite for URL rewrite and mod_headers for .htaccess extra headers like Access-Control-Allow-Origin-
RUN a2enmod rewrite headers

# Instale o Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Entrando no diretorio de trabalho
WORKDIR /var/www/html

# Instale as dependências do Laravel com o Composer
COPY ./composer.* ./
RUN composer install --no-autoloader && rm -rf /root/.composer

# Copiando codigo do projeto
COPY --chown=www-data:www-data . .

# Criando arquivos de autoload
RUN composer dump-autoload
