# Rizzo

The app that serves global common meta head definitions, global-body-header and global-body-footer for lp new style guides.
Rizzo also acts as a global service for beacon endpoint, redirector and errors.


## Install

    $ git clone git@github.com:lonelyplanet/rizzo.git
    $ cd rizzo
    $ cp .rvmrc.example .rvmrc
    $ source .rvmrc
    $ (gem install bundle if not available)
    $ bundle install


## Usage
You can run rizzo as a server, or as an extension engine for a rails app. 

### As a standalone server

    - bundle exec unicorn

### As an engine on your rails app

    - add rizzo gem in the gemfile
      gem 'rizzo', git: 'git@github.com:lonelyplanet/rizzo.git'
      

