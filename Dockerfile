FROM speed_nginxssl_4
#FROM speed_wordpress_3
#FROM speed_phpmyadmin_2
#FROM speed_buster_1

##stage1
#FROM debian:buster
#RUN apt-get update
#RUN apt-get install -y php php-fpm default-mysql-server nginx unzip wget
#MAINTAINER jyelena <jyelena@student.21-school.ru>

##stage2
#RUN mkdir /var/www/ftsite
#RUN mkdir /tmp/phpmyadmin
#WORKDIR /tmp/phpmyadmin
#RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.zip
#RUN unzip phpMyAdmin-5.0.4-all-languages.zip
#RUN mv phpMyAdmin-5.0.4-all-languages /var/www/ftsite/phpmyadmin
#COPY ./srcs/phpmyadmin.inc.php /var/www/ftsite/phpmyadmin/config.inc.php
#WORKDIR /
#RUN rm -Rf /tmp/phpmyadmin

##stage3
#RUN mkdir /tmp/wordpress
#WORKDIR /tmp/wordpress
#RUN wget https://wordpress.org/latest.zip
#RUN unzip latest.zip
#RUN mv wordpress /var/www/ftsite/
#COPY ./srcs/wp-config.php /var/www/ftsite/wordpress/
#WORKDIR /
#RUN rm -Rf /tmp/wordpress

##stage4
#RUN mkdir /etc/nginx/ssl_certs
#RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl_certs/private.pem -keyout /etc/nginx/ssl_certs/public.key -subj "/C=RU/ST=KAZAN/L=KAZAN/OU=21school/"
#RUN openssl rsa -noout -text -in /etc/nginx/ssl_certs/public.key

#stage5
RUN chown -R www-data /var/www/*
RUN chmod -R 755 /var/www/*

COPY ./srcs/nginx.conf /etc/nginx/sites-available/ftsite
RUN ln -s /etc/nginx/sites-available/ftsite /etc/nginx/sites-enabled/ftsite
RUN rm -Rf /etc/nginx/sites-enabled/default

COPY ./srcs/*.sh /tmp/
COPY ./srcs/*.sql /tmp/
COPY ./srcs/index.php /var/www/ftsite/

EXPOSE 80 443

ENTRYPOINT sh /tmp/server_init.sh && cat /var/log/nginx/error.log && /bin/bash
#ENTRYPOINT /bin/bash