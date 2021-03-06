#stage1
FROM debian:buster
RUN apt-get update && apt-get install -y php php-mysql php-fpm php-mbstring default-mysql-server nginx unzip wget
RUN mkdir /tmp/phpmyadmin /tmp/wordpress /etc/nginx/ssl_certs

#stage2
WORKDIR /tmp/wordpress
RUN wget https://wordpress.org/latest.zip
RUN unzip latest.zip
RUN mv wordpress /var/www/ftsite
COPY ./srcs/wp-config.php /var/www/ftsite/

#stage3
WORKDIR /tmp/phpmyadmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.zip
RUN unzip phpMyAdmin-5.0.4-all-languages.zip
RUN mv phpMyAdmin-5.0.4-all-languages /var/www/ftsite/phpmyadmin
COPY ./srcs/phpmyadmin.inc.php /var/www/ftsite/phpmyadmin/config.inc.php

#stage4
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl_certs/private.pem -keyout /etc/nginx/ssl_certs/public.key -subj "/C=RU/ST=KAZAN/L=KAZAN/OU=21school/"
RUN openssl rsa -noout -text -in /etc/nginx/ssl_certs/public.key

#stage5
RUN chown -R www-data /var/www/*
RUN chmod -R 755 /var/www/*

COPY ./srcs/nginx.conf /etc/nginx/sites-available/ftsite.conf
RUN ln -s /etc/nginx/sites-available/ftsite.conf /etc/nginx/sites-enabled/ftsite.conf
RUN rm -Rf /etc/nginx/sites-enabled/default /tmp/wordpress /tmp/phpmyadmin
WORKDIR /

COPY ./srcs/*.sh /tmp/
COPY ./srcs/*.sql /tmp/

EXPOSE 80 443

ENTRYPOINT sh /tmp/server_init.sh && cat /var/log/nginx/error.log && /bin/bash