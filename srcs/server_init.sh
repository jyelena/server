#chmod 755 ./start.sh
#chmod 755 ./change_automation.sh

service nginx start
service mysql start
service $(ls /etc/init.d | grep php | grep fpm) start
mysql < ./tmp/wp_database.sql

# chown -R www-data /var/www/localhost
# chmod -R 755 /var/www/localhost