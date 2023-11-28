# File: 7-puppet_install_nginx_web_server.pp

# Install Nginx package
package { 'nginx':
  ensure => installed,
}

# Ensure Nginx service is running and enabled
service { 'nginx':
  ensure  => running,
  enable  => true,
  require => Package['nginx'],
}

# Configure Nginx server
file { '/etc/nginx/sites-available/default':
  ensure  => file,
  content => "
    server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;

        server_name _;

        location /redirect_me {
            return 301 https://www.youtube.com/watch?v=QH2-TGUlwu4;
        }

        location / {
            return 200 'Hello World!';
        }

        # Other server configurations...
    }
  ",
  require => Package['nginx'],
  notify  => Service['nginx'],
}

# Remove default Nginx default site configuration
file { '/etc/nginx/sites-enabled/default':
  ensure => absent,
}

# Reload Nginx to apply changes
exec { 'nginx-reload':
  command => 'service nginx reload',
  path    => '/usr/bin',
  require => File['/etc/nginx/sites-available/default'],
}

