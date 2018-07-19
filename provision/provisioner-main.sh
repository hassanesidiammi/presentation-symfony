!/bin/bash

server_jenkins="chaine-jenkins"
server_app="chaine"

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo apt-add-repository "deb https://pkg.jenkins.io/debian-stable binary/"


sudo apt-get update
sudo apt-get install -y php php-fpm php-zip php-curl php-xmlrpc php-gd php-mysql php-mbstring php-xml
# sudo apt-get install -y php-pear php-dev
sudo apt-get --purge autoremove -y
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo apt-get -y install mysql-server mysql-client openjdk-8-jdk php-xdebug
sudo update-alternatives --config java

sudo apt-get remove -y apache2
sudo apt autoremove -y
sudo apt-get install -y ant git-core curl unzip nginx phpcpd
sudo apt install -y jenkins php-codesniffer

sudo wget  --directory-prefix=/usr/share/ http://www.phpdoc.org/phpDocumentor.phar
sudo ln -s /usr/share/phpDocumentor.phar /usr/bin/phpdoc
sudo chmod +x /usr/bin/phpdoc

sudo cat > /etc/nginx/sites-available/$server_app <<- EOM
server {
    listen 80;
    listen [::]:80 ipv6only=on;
    root /vagrant;
    index index.php index.html index.htm;
    server_name $server_app;
    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }
    location ~ \.php\$ {
        try_files \$uri /index.php =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)\$;
        fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOM

sudo cat > /etc/nginx/sites-available/$server_jenkins <<- EOM2
server {
    listen 80;
    server_name $server_jenkins;
    location / {
      proxy_set_header        Host \$host:\$server_port;
      proxy_set_header        X-Real-IP \$remote_addr;
      proxy_set_header        X-Forwarded-For \$proxy_add_x_forwarded_for;
      proxy_set_header        X-Forwarded-Proto \$scheme;
      # Fix the "It appears that your reverse proxy set up is broken" error.
      proxy_pass          http://127.0.0.1:8080;
      proxy_read_timeout  90;
      proxy_redirect      http://127.0.0.1:8080 http://$server_jenkins;
      proxy_redirect      http:$server_jenkins:8080 http://$server_jenkins;
    }
  }
EOM2

sudo ln -s -f /etc/nginx/sites-available/$server_jenkins /etc/nginx/sites-enabled/$server_jenkins
sudo ln -s -f /etc/nginx/sites-available/$server_app /etc/nginx/sites-enabled/$server_app

echo $USER
cd /tmp
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
php -r "unlink('composer-setup.php');"
sudo chown -R www-data:www-data ~/.composer/
echo -n 'Curent Home dir is: '
echo $HOME
sleep 30

sudo service jenkins restart
sudo service mysql start
sudo service php7.2-fpm restart
sudo service nginx restart

sleep 30
cd /home/vagrant/
sudo wget http://localhost:8080/jnlpJars/jenkins-cli.jar
sudo cp /var/lib/jenkins/config.xml /var/lib/jenkins/config_.xml
sudo ex +g/useSecurity/d +g/authorizationStrategy/d -scwq /var/lib/jenkins/config.xml
echo 'ls -AlFh /var/lib/jenkins/ | grep config: '
ls -AlFh /var/lib/jenkins/ | grep config
sudo service jenkins restart
sleep 30
sudo java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin \
     checkstyle cloverphp crap4j dry htmlpublisher jdepend plot pmd violations warnings xunit git greenballs
	 #Publish Over SSH, Audit Trail, Token Macro, Email Extension, Task Scanner,Phing, Post build task
echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount("admin", "admin")' | \
java -jar jenkins-cli.jar -s http://localhost:8080 groovy =

java -jar jenkins-cli.jar  -s http://127.0.0.1:8080 create-job presentation < /vagrant/app/presentation.xml
sleep 30
sudo mv -f /var/lib/jenkins/config_.xml /var/lib/jenkins/config.xml
ls -AlFh /var/lib/jenkins/ | grep config
sudo chown jenkins:jenkins /var/lib/jenkins/config.xml
ls -AlFh /var/lib/jenkins/ | grep config
sudo service jenkins restart

echo ' Provisinig Complet !!! '
{
	echo -e "The project server: \t http://$server_app"
	echo -e "Jenkins server: \t http://$server_jenkins"
} > /vagrant/infos.txt






















