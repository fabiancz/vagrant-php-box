# vagrant-php-devbox

[Vagrant](http://www.vagrantup.com/) configuration for Apache, PHP, MySQL, [sass](http://sass-lang.com), [foundation](http://foundation.zurb.com), [compass](http://compass-style.org)

This project is inspired by [evansims/vagrant-devbox](https://github.com/evansims/vagrant-devbox), but it's not fork of it.:)

## Install
How to install this development environment:

1. Install [Vagrant](http://www.vagrantup.com/downloads.html) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Clone this repo and go to your local copy in terminal
3. Install modules with command `git submodule update --init` (in repo dir)
4. Bring everything up with `vagrant up`. It will take some time to download vagrant box. Then [Puppet](http://puppetlabs.com) will deal with installation and configuration of the services.

Test your installation by pointing your browser to [http://localhost:8081](http://localhost:8081)

## Setup project
How to get your PHP project up and running from vagrant virtualhost:

1. Clone project from your repo (or just create new locally) to htdocs/<project>/
2. Create yourproject.apache.conf file anywhere in your project folder (see htdocs/example/example.apache.conf)
3. SSH to your running vagrant: `vagrant ssh`
4. Run script `vg-link-vhosts` (it links apache vhosts to sites-enabled and reloads apache)
5. Update your /etc/hosts based on result of `vg-link-vhosts` script output
6. Point your browser to ServerName specified in yourproject.apache.conf

## Working with sass, compass, foundation

### Create new [foundation](http://foundation.zurb.com) project:

1. SSH to your running vagrant: `vagrant ssh`
2. Navigate to vagrant folder: `cd /vagrant/htdocs`
3. Run `foundation new <projectname>`

Remember to create new svn/git repo for this project and commit from your host mashine.

### If you want to watch your CSS files and preproccess them by [compass](http://compass-style.org):

1. SSH to your running vagrant: `vagrant ssh`
2. Navigate to vagrant folder: `cd /vagrant/htdocs`
3. Run `compass watch <yourproject>`