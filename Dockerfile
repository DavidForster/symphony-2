FROM php:5-apache

# Update packages, Install libxslt, zlib and Git
RUN apt-get update \
    && apt-get install -y \
        git \
        libxslt1-dev \
        zlib1g-dev \
    && apt-get clean \
    && apt-get autoremove \
    && rm -r /var/lib/apt/lists/*

# enable mysqli, xsl and zlib PHP modules
RUN docker-php-ext-install \
    mysqli \
    xsl \
    zip

# enable mod_rewrite
RUN a2enmod rewrite

# Copy the repository into the working directory
COPY . .

# Add the standard submodules and workspace
RUN git submodule add git://github.com/symphonycms/export_ensemble.git extensions/export_ensemble --recursive \
	&& git submodule add git://github.com/symphonycms/markdown.git extensions/markdown --recursive \
	&& git submodule add git://github.com/symphonycms/maintenance_mode.git extensions/maintenance_mode --recursive \
	&& git submodule add git://github.com/symphonycms/selectbox_link_field.git extensions/selectbox_link_field --recursive \
	&& git submodule add git://github.com/symphonycms/jit_image_manipulation.git extensions/jit_image_manipulation --recursive \
	&& git submodule add git://github.com/symphonycms/profiledevkit.git extensions/profiledevkit --recursive \
	&& git submodule add git://github.com/symphonycms/debugdevkit.git extensions/debugdevkit --recursive \
	&& git submodule add git://github.com/symphonycms/xssfilter.git extensions/xssfilter --recursive \
    && git clone git://github.com/symphonycms/workspace.git

# Recursively change the owner and group of all files to www-data
RUN chown -R www-data:www-data .
