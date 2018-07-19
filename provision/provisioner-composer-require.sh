#!/bin/bash


cd /vagrant
composer install
cat /vagrant/infos.txt | column -t -s $'\t'