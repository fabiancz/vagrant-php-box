#!/bin/bash

####
# This script looks to $vagrant_htdocs_dir, find all files match pattern $apache_conf_pattern
# and symlink these files to $vagrant_vhosts_dir
#
# Apache is including these config files from $vagrant_vhosts_dir for serving websites.
#
# At the end this script prints hint, how you can set your /etc/hosts to access websites from host mashine.
####

vagrant_hostname="precise32"
vagrant_ip="192.168.33.10"
apache_conf_pattern="*.apache.conf"
vagrant_htdocs_dir="/vagrant/htdocs"
vagrant_vhosts_dir="/etc/apache2/sites-enabled"

apache_vhost_ls() {
	for i in "$1"/*;do
	    if [ -d "$i" ];then
	        apache_vhost_ls "$i"
	    elif [ -f "$i" ]; then
	    	if [[ $i == $apache_conf_pattern ]]; then
	    		filename=`basename $i`
	        	sudo ln -s $i $vagrant_vhosts_dir/$filename
	        fi
	    fi
	done
}

if [ `hostname` != "$vagrant_hostname" ]; then
	echo "ERROR: you have to run this script from inside of vagrant virtual!"
	exit
fi

echo "LOOKING FOR APACHE CONFIG FILES $apache_conf_pattern IN $vagrant_htdocs_dir"

sudo rm -f $vagrant_vhosts_dir/*.apache.conf
apache_vhost_ls $vagrant_htdocs_dir
echo "CONFIG FILES SYMLINKED TO $vagrant_vhosts_dir"
sudo /etc/init.d/apache2 reload
echo "FINISHED"
echo ""

# should be nicer, or replaced by dnsmasq
echo "UPDATE YOUR /etc/hosts:"
for conf in $vagrant_vhosts_dir/$apache_conf_pattern; do
	servername=`cat $conf|grep ServerName`
	if [[ "$servername" != "" ]]; then
		echo "$vagrant_ip "`expr "$servername" : '^\s*ServerName \(.*\)'`
	fi
	servername=`cat $conf|grep ServerAlias`
	if [[ "$servername" != "" ]]; then
		echo "$vagrant_ip "`expr "$servername" : '^\s*ServerAlias \(.*\)'`
	fi
done
echo ""