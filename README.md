# Vagrant VM with LAMP, PHPMyAdmin and Load&Dump Database

This repository creates a vagrant VM with a LAMP environment. Vagrant loads a sql file to create a database and PHPMyAdmin is accesible to handle.
When the machine Vagrant shuts down, it creates a backup of the database.

##Virtual Machine
	- Ubuntu 14.04 LTS (trusty)
	- Apache
	- MySQL
	- PHP
	- Pear
	- Setup TimeZone
	- MySQL user and database
	- PHPMyAdmin
	- mod_rewrite
	- mcrypt
	- git
	- composer

##Prerequisites
1. You must have vagrant installed.
2. If you want to enable automatic backups, you have to install vagrant-triggers plugin:

    $ vagrant plugin install vagrant-triggers

##Config
It is possible change TimeZone, database's name, user and password in bootstrap.sh and sql/dump/dump.sh

##Quick Start
1. Clone the repo: git clone git://github.com/jorbriib/vagrant-lamp-phpmyadmin-load-dump-db.git
2. To load a database, copy a script 'database.sql' in the 'sql' folder.
3. Launch machines with command: vagrant up.
4. Copy your web site in the shared folder 'www'.
