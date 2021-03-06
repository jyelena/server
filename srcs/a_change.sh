sed -i {'s/autoindex off/autoindex on/'} /etc/nginx/sites-available/ftsite.conf
service nginx reload