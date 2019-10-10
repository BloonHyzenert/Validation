#!/usr/bin/env bash

#Installation of VirutalBox and vagrant

if [[ -n $(vboxmanage --version) ]]
then
  echo -e "\e[34mVirtualBox est déjà installé\e[0m"
else
  echo -e "\e[34mInstallation de VirtualBox\e[0m"
  sudo apt install virtualbox-qt
fi

if [[ -n $(vagrant -v) ]]
then
  echo -e "\e[34mvagrant est déjà installé\e[0m"
else
  echo -e "\e[34mInstallation de vagrant\e[0m"
  sudo apt install vagrant
fi

#Creation of vagrantfile
echo -e "\e[34mCréation du Vagrantfile\e[0m"
if [ ! -e Vagrantfile ]
then
  touch Vagrantfile
fi

#Choix de la box
echo 'Vagrant.configure("2") do |config|'>Vagrantfile
read -p "Entrer le numéro de la box à télécharger comme 1 : ubuntu/xenial64, 2 : ubuntu/trusty64 ou 3 : centos/7?" box
if [[ $box == 1 ]]
then
  boxName="ubuntu/xenial64"
elif [[ $box == 2 ]]
then
  boxName="ubuntu/trusty64"
elif [[ $box == 3 ]]
then
  boxName="centos/7"
else
  boxName="ubuntu/xenial64"
fi
echo 'config.vm.box = "'$boxName'"'>>Vagrantfile

#Choix de l'IP
read -p "Entrer un nombre pour le dernier octet de l'adresseIP : 19.168.33.?" ip
echo 'config.vm.network "private_network", ip: "192.168.33.'$ip'"'>>Vagrantfile

#Choix des noms de dossiers
read -p "Quel nom voulez-vous donner au dossier synchronisé local?" local
read -p "Quel nom voulez-vous donner au dossier synchronisé distant?" distant
echo 'config.vm.synced_folder "./'$local'", "/var/www/'$distant'"'>>Vagrantfile
echo 'end'>>Vagrantfile

rm -rf $local
mkdir $local

echo ''
# list of running vagrant
l=$(vagrant global-status | grep running)
echo -e "\e[34m$l\e[0m"
read -p "Voulez-vous eteindre un de ces vagrant? O/n" response
if [[ $response == "O" ]]
then
  read -p "Veuillez entrer son id" id
  vagrant halt $id
fi

echo ''
#Vagrant up + installation LAMP
echo -e "\e[34mLancement du vagrant\e[0m"
read -p "Voulez-vous lancer votre vagrant? O/n" response
if [[ $response == "O" ]]
then
  vagrant up
  echo 'Installation de LAMP'
  vagrant ssh -c 'sudo apt install -y apache2 php7.0'
  vagrant ssh -c 'echo "0000" | sudo apt install -y mysql-server'
fi
