#Development usage
## Setup
	$ [sudo] gem install bundle
	$ [sudo] bundle install
    $ [bundle exec] rake db:migrate
## Running

	$ [bundle exec] rails s

Optionally, if you need to run long tasks, you should run the job worker:

    $ [bundle exec] rake jobs:work

To run the unit tests:

    $ [bundle exec] rake test


#Architecture

	├── Gemfile
	├── Gemfile.lock
	├── Rakefile
	├── app
	│   ├── controllers
	│   │   ├── application_controller.rb #super class of * controllers. Handle auth + environement setup
	│   │   └── mpsynthesizer_controller.rb #Handle synthetisizer backend interactions
	│   │   └── mpanalyser_controller.rb #Handle analyser backend interactions
	│   ├── models #Empty
	│   └── views #Empty
	├── bin
    │   ├── mpanalyzer # Shell script to execute correct bin arch (Linux/Darwin)
    │   ├── mpface # Same as above
    │   ├── mpsynth # Same as above
	│   ├── linux
	│   │   ├── facefp
	│   │   ├── mpanalyser
	│   │   └── mpsynth
	│   ├── osx
	│   │   ├── facefp
	│   │   ├── mpanalyser
	│   │   └── mpsynth
	├── config
	│   ├── application.rb # Few custom settings here
	│   ├── configuration.yml # The configuration file
	│   ├── routes.rb # Handles routing to our controller
	├── lib
	│   ├── assets
	│   │   └── mpsynth # mpsynth .bin, _data, ...
	│   ├── synthesizer.rb # The binnary wrapper
	├── test
	├── tmp
	│   ├── mpsynth
	│   │   └── work # Working directory contains temporary files used to enable ruby/executable communication

#Deployment

The master repository for deployment is on github.

Check that your code is uploaded to the correct remote.


    # On your computer, within serverapi_rails folder run:
    $ [CAP_BRANCH=a_branch_name] [bundle exec] cap [staging | sdkserver] deploy

branch defaults to:

- develop for staging
- master for sdkserver

Do NOT modify directly the repository on the server.
If this is the first time for you to deploy on the server, you'll need to add your public key to allow ssh access.


# Notes

Some executable files are included. Currently for linux and osx only.
Crons tasks are automatically deployed; tho not in development mode.
Crons are handleded by whenever gem.

# Troubleshooting

The most common error you will encounter is incorrect binary or missing libraries.

## macOS
On mac os, dependencies can be installed with homebrew.
Here is how to install them:

    brew tap homebrew/science
    brew install xerces-c opencv ffmpeg libpng libjpeg

Non brewable dependencies include XQuartz


## Linux Ubuntu

1. Install xerces-c
$sudo apt-get install libxerces-c-dev libxerces-c3.1
2. Install opencv 
$ sudo apt-get install build-essential
$ sudo apt-get install cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
$ sudo apt-get install python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff5-dev libdc1394-22-dev
3. Intall ffmpeg
$ sudo apt-get install ffmpeg

https://www.xquartz.org
