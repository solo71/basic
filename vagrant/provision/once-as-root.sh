#!/usr/bin/env bash

#== Import script args ==

timezone=$(echo "$1")

#== Bash helpers ==

function info {
  echo " "
  echo "--> $1"
  echo " "
}

#== Provision script ==

info "Provision-script user: `whoami`"

export DEBIAN_FRONTEND=noninteractive

info "Configure timezone"
timedatectl set-timezone ${timezone} --no-ask-password

info "Prepare root password for MySQL"
debconf-set-selections <<< "mariadb-server-10.0 mysql-server/root_password password \"''\""
debconf-set-selections <<< "mariadb-server-10.0 mysql-server/root_password_again password \"''\""
echo "Done!"

info "Add ElasticSearch sources"
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-5.x.list

info "Update OS software"
apt-get update
apt-get upgrade -y

info "Install additional software"
apt-get install -y php7.0-curl php7.0-cli php7.0-intl php7.0-mysqlnd php7.0-gd php7.0-fpm php7.0-mbstring php7.0-xml unzip nginx mariadb-server-10.0 php.xdebug


info "Install JDK"
apt-get install default-jdk

info "Install MC"
apt-get install -y mc

info "Install ElasticSearch"
apt-get install -y elasticsearch
sed -i 's/-Xms2g/-Xms64m/' /etc/elasticsearch/jvm.options
sed -i 's/-Xmx2g/-Xmx64m/' /etc/elasticsearch/jvm.options

info "Install Redis"
apt-get install -y redis-server

info "Install Supervisor"
apt-get install -y supervisor

info "Configure MySQL"
sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
mysql -uroot <<< "CREATE USER 'root'@'%' IDENTIFIED BY ''"
mysql -uroot <<< "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'"
mysql -uroot <<< "DROP USER 'root'@'localhost'"
mysql -uroot <<< "FLUSH PRIVILEGES"
echo "Done!"

info "Configure PHP-FPM"
sed -i 's/user = www-data/user = vagrant/g' /etc/php/7.0/fpm/pool.d/www.conf
sed -i 's/group = www-data/group = vagrant/g' /etc/php/7.0/fpm/pool.d/www.conf
sed -i 's/owner = www-data/owner = vagrant/g' /etc/php/7.0/fpm/pool.d/www.conf
cat << EOF > /etc/php/7.0/mods-available/xdebug.ini
zend_extension=xdebug.so
xdebug.remote_enable=1
xdebug.remote_connect_back=1
xdebug.remote_port=9000
xdebug.remote_autostart=1
EOF
echo "Done!"

info "Configure NGINX"
sed -i 's/user www-data/user vagrant/g' /etc/nginx/nginx.conf
echo "Done!"

info "Enabling site configuration"
ln -s /app/vagrant/nginx/app.conf /etc/nginx/sites-enabled/app.conf
echo "Done!"

info "Removing default site configuration"
rm /etc/nginx/sites-enabled/default
echo "Done!"

info "Initailize databases for MySQL"
mysql -uroot <<< "CREATE DATABASE basic"
echo "Done!"

info "Enabling supervisor processes"
ln -s /app/vagrant/supervisor/queue.conf /etc/supervisor/conf.d/queue.conf
echo "Done!"

info "Install composer"
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer