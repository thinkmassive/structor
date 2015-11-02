#  Licensed to the Apache Software Foundation (ASF) under one or more
#   contributor license agreements.  See the NOTICE file distributed with
#   this work for additional information regarding copyright ownership.
#   The ASF licenses this file to You under the Apache License, Version 2.0
#   (the "License"); you may not use this file except in compliance with
#   the License.  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

class postgres_server {
  require repos_setup

  $path = "/sbin:/usr/sbin:/bin:/usr/bin"

  # Client.
  package { "postgresql":
    ensure => installed,
  }

  # Server.
  package { "postgresql-server":
    ensure => installed,
  }
  ->
  exec { 'service postgresql initdb':
    cwd => "/",
    path => "${path}",
    creates => '/var/lib/pgsql/data/pg_log',
  }
  ->
  file { '/var/lib/pgsql/data/pg_hba.conf':
    ensure => file,
    source => "puppet:///modules/postgres_server/pg_hba.conf",
    owner => postgres,
    group => postgres,
    mode => '600',
  }
  ->
  file { '/var/lib/pgsql/data/postgresql.conf':
    ensure => file,
    source => "puppet:///modules/postgres_server/postgresql.conf",
    owner => postgres,
    group => postgres,
    mode => '600',
  }
  ->
  service { 'postgresql':
    ensure => running,
    enable => true,
    before => Exec['createuser -sw vagrant'],
  }

  exec { 'createuser -sw vagrant':
    cwd => "/",
    path => "${path}",
    user => "postgres",
    unless => 'grep vagrant /var/lib/pgsql/data/global/pg_auth',
  }
  ->
  exec { 'createdb vagrant':
    cwd => "/",
    path => "${path}",
    user => "postgres",
    unless => 'grep vagrant /var/lib/pgsql/data/global/pg_database',
  }
}
