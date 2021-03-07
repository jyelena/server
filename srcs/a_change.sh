cat /etc/nginx/sites-available/ftsite.conf | grep autoindex
sed -i {'s/autoindex on/autoindex off/'} /etc/nginx/sites-available/ftsite.conf
cat /etc/nginx/sites-available/ftsite.conf | grep autoindex
service nginx reload