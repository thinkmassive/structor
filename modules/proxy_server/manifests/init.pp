
class proxy_server {

  require repos_setup

  package { "squid":
    ensure => installed
  }
  ->
  exec { "squid-init":
    command => "/usr/sbin/squid -z"
  }
  ->
  file { "/etc/squid/squid.conf":
    ensure => file,
    content => template('proxy_server/squid.conf.erb'),
    owner => 'root',
    group => 'squid',
    mode => '640'
  }
  ->
  service {"squid":
    ensure => running,
    enable => true
  }
}
