Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }
exec { 'apt-get update':
	command => 'apt-get update',
}

class setup_apache {
	package { 'apache2':
		ensure  => "installed",
		require => Exec['apt-get update']
	}
	service { 'apache2':
		ensure    => running,
		enable    => true,
		require => Package['apache2']
	}
}

class setup_php {
	package { ['libapache2-mod-php5', 'php5', 'php5-mysql', 'php5-mcrypt']:
		ensure  => "installed",
		require => Exec['apt-get update'],
	}
	exec { 'composer':
		command => 'curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer',
		require => Package['php5']
	}
}

class setup_mysql {
	package { ['mysql-server']:
		ensure  => "installed",
		require => Exec['apt-get update'],
	}
	service { 'mysql':
	  ensure    => running,
	  enable    => true,
	  require => Package['mysql-server'],
	}
}

class setup_toolbox {
	package { [ "htop", "curl", "mc" ]:
		ensure  => "installed",
		require => Exec['apt-get update'],
	}
	file { 'link-vhosts.sh':
		name => '/usr/local/bin/vg-link-vhosts',
		ensure => present,
		source => '/vagrant/bin/vg-link-vhosts.sh',
	}
}

class setup_sass {
	# we don't need to include nodejs. It's included by this call, and variable manage_repo is se to true
	# see http://stackoverflow.com/questions/22696271/puppet-set-variable-in-nodejs-module/22697182 for details:)
	class {'nodejs':
		manage_repo => true,
	}

	# newer ruby for foundation
	package { ['python-software-properties', 'python', 'g++', 'make']:
		ensure => 'installed',
		require => Exec['apt-get update'],
	}
	package { ['git', 'ruby1.9.1' ]:
		ensure => 'installed',
		require => Exec['apt-get update'],
	}
	# foundation (http://foundation.zurb.com/docs/sass.html)
	package { ['bower', 'grunt-cli']:
		ensure => 'installed',
		provider => 'npm',
		require => Package['nodejs'],
	}
	package { 'foundation':
		ensure => 'installed',
		provider => 'gem',
		require => [ Package['ruby1.9.1'], Package['bower'], Package['grunt-cli'] ],
	}
	# compass (http://compass-style.org/), ktery si sam jako zavislost pres gem nainstaluje sass
	package { 'compass':
		ensure => 'installed',
		provider => 'gem',
		require => [ Package['ruby1.9.1'] ],
	}
}

include setup_toolbox
include setup_apache
include setup_php
include setup_mysql
include setup_sass