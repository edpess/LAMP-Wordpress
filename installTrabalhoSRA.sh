#!/bin/bash

echo "instalação padrão para Debian Stretch"

sudo apt-get update

#instala docker

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common -y

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io -y

apt-cache madison docker-ce

  docker-ce | 5:18.09.1~3-0~debian-stretch | https://download.docker.com/linux/debian stretch/stable amd64 Packages
  docker-ce | 5:18.09.0~3-0~debian-stretch | https://download.docker.com/linux/debian stretch/stable amd64 Packages
  docker-ce | 18.06.1~ce~3-0~debian        | https://download.docker.com/linux/debian stretch/stable amd64 Packages
  docker-ce | 18.06.0~ce~3-0~debian        | https://download.docker.com/linux/debian stretch/stable amd64 Packages
  ...

#testa docker

sudo docker run hello-world

#instala docker-compose version 1.24.0, build 0aa59064

sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

#cria arquivo docker-compose

cat > docker-compose.yml <<EOF
version: '3.3'

services:
   db:
     image: mysql:5.7
     volumes:
       - db_data:/var/lib/mysql
     restart: always
     environment:
       MYSQL_ROOT_PASSWORD: somewordpress
       MYSQL_DATABASE: wordpress
       MYSQL_USER: wordpress
       MYSQL_PASSWORD: wordpress

   wordpress:
     depends_on:
       - db
     image: wordpress:latest
     ports:
       - "8000:80"
     restart: always
     environment:
       WORDPRESS_DB_HOST: db:3306
       WORDPRESS_DB_USER: wordpress
       WORDPRESS_DB_PASSWORD: wordpress
       WORDPRESS_DB_NAME: wordpress
volumes:
    db_data: {}
EOF

#Configura a instalação de acordo com o arquivo docker-composer

docker-compose up -d

#instala PHP 7

sudo apt -y install php php-cgi libapache2-mod-php php-common php-pear php-mbstring 

echo "date.timezone = America/Fortaleza" >> /etc/php/7.0/apache2/php.ini 
sudo systemctl restart apache2 

sudo mv /var/www/html/index.html /var/www/html/old_index.html
sudo cat > /var/www/html/index.php <<EOF
<html>
<body>
<h1>Pagina de teste PHP</h1>

<div style="width: 100%; font-size: 40px; font-weight: bold; text-align:center;">
<?php
      print Date("d/m/Y");
?>
</div>
</body>
</html>
EOF

#abre o navegador padrão a instalação do WordPress
xdg-open 'http://127.0.0.1:8000'

#abre o navegador padrão uma página teste do PHP Apache 
xdg-open 'http://127.0.0.1'
