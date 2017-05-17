#Deployment

## Requirements

- Any machine able to run ruby > 2.1 and < 2.4
- The application can run on a large variety of setups. This is the recommended one:

## Setup

* ruby 2.3.3 (Other versions not tested but should work)
* Phusion Passenger/Unicorn/Other application server
* Nginx (Usually installed by Phusion Passenger)
* rvm 1.27.0 (optional, recommended; other versions should work)
* Ruby gems: See Gemfile, Gemfile.lock

### The following packages should be present for installation:

> build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison git libcurl4-openssl-dev freeglut3 freeglut3-dev imagemagick libjpeg-dev libpng12-dev libjpeg62 ffmpeg




### Installation

Recommended OS: **Ubuntu 14.04.4 LTS**

See recommended [tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-rails-and-nginx-with-passenger-on-ubuntu) for complete installation.

You will need to add ffmpeg repo to your sources:

https://launchpad.net/~kirillshkrogalev/+archive/ubuntu/ffmpeg-next

#### Apache

You need to add this fields to the configuration file.
If you use virtual hosts, it must be enabled specifically for the virtual hosts, the setting is not inherited

      Header always set Access-Control-Allow-Origin "*"
      Header always set Access-Control-Allow-Methods "POST, GET, OPTIONS, DELETE, PUT"
      Header set Access-Control-Allow-Credentials "true"
      Header always set Access-Control-Allow-Headers "x-requested-with, Content-Type, origin, authorization, accept, client-security-token"



### Warning

This app present security issues on windows OS.
