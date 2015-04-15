FROM debian:wheezy

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -y install nginx php5-fpm php5-cli php5-mysql php5-mcrypt php5-curl php5-gd php5-intl curl supervisor
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* \
           /tmp/* \
           /var/tmp/*

# Avoid auto-daemonizaiton
RUN sed -i -e 's/;daemonize = yes/daemonize = no/' /etc/php5/fpm/php-fpm.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

VOLUME ["/var/www", "/etc/nginx/sites-available", "/etc/nginx/sites-enabled"]

# Workdir
RUN mkdir -p /var/www
WORKDIR /var/www

CMD ["/usr/bin/supervisord"]

EXPOSE 80

