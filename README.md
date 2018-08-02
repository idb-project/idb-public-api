# This is the public API of the IDB core application.

In order to submit maintenace logs from a machine into the IDB application one needs this public API.
It accepts maintenance logs submitted by an LDAP user via the idb-service script, and adds it to an
ActiveMQ queue where it gets polled from the IDB core application.

## Setup

- jruby 9.0.0.0 is necessary to build this project
- OpenJDK 7 is necessary
- run 'gem install bundler' to install bundler
- run 'bundle install' to install required gems
- rename 'Rakefile.example' to 'Rakefile' and adapt to your needs
- rename 'config.yml.example' to 'config.yml' and adapt to your needs

## Building

- Adapt version if needed: lib/idb.rb
- Run 'bundle exec rake' to generate the .jar file. Generation is done by warbler, has its own config in config directory.

## Deployment

- Upload the jar to the server.
- Adjust symlink in /usr/share/bytemine-idb-public-api to point to new jar
- Adapt service config to the new jar name: /etc/init/bytemine-idb-public-api.conf
- Restart the service

