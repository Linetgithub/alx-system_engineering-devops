# Puppet manifest to add a custom HTTP response header to Nginx
# The custom header is X-Served-By, and its value is the hostname of the server

package { 'nginx':
  ensure => installed,
}

service { 'nginx':
  ensure => running,
}

file { '/etc/nginx/sites-available/default':
  content => "server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;
    
    location / {
        add_header X-Served-By $hostname;
        root /var/www/html;
        index index.html index.htm;
    }
}",
  notify  => Service['nginx'],
}

file { '/etc/nginx/sites-enabled/default':
  ensure => 'link',
  target => '/etc/nginx/sites-available/default',
  notify => Service['nginx'],
}

