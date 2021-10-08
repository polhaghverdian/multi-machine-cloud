exec { "apt-update":
  command     => "/usr/bin/apt-get update",
  timeout     => 300,
}


node 'appserver.network', 'appserver' {

  # Download and execute the node script
  exec {"Add node.js":
    command => '/usr/bin/curl -sL https://deb.nodesource.com/setup_15.x | sudo -E bash -'
  }

  # Install node
  exec {"Install node.js":
    command => '/usr/bin/apt-get install -y nodejs',
    timeout     => 500,
  }

}

node 'dbserver.network', 'dbserver' {

  # Install mysql
  package { ['mysql-server']:
    ensure => present,
    require => Exec['apt-update']
  }

  # Run mysql
  service { 'mysql':
    ensure  => running,
    require => Package['mysql-server'],
  }

}
