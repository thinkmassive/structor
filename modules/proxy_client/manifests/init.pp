class proxy_client {
  exec { 'yum proxy':
    command => "sed -i '/proxy=http\:\/\/240.0.0.10\:3128/d' /etc/yum.conf && echo 'proxy=http://240.0.0.10:3128' >> /etc/yum.conf",
    path => [ "/bin" ]
  }
}
