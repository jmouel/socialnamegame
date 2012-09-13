socialnamegame
======

Sample application for Dreamforce 2012. Tests your ability to identify your social contacts (Twitter, Facebook, LinkedIn, Salesforce)
using their profile pictures.



Getting Started
---------------

The following are instructions for OS X 10.8:

### Environment Setup

#### Xcode
- Install [Xcode](http://developer.apple.com/tools/xcode/).
- Install the Xcode Command Line Tools.
  - Launch Xcode. Select Xcode > Preferences, click Downloads tab, and click the Install button for the Command Line Tools.

#### Homebrew
- http://mxcl.github.com/homebrew/

#### PostgreSQL
- Install PostgreSQL 9. ``brew install postgresql``

#### Ruby
- Install Ruby 1.9. ``brew install ruby``
- Override the standard Mac OS X install of Ruby by modifying the /etc/paths and moving the home-brews to the top of the file (/usr/local/bin), and also point /usr/bin/bundle at the new ruby interpreter location as well (first line). Or use rvm or rbenv.
- Install bundler. ``sudo gem install bundler``
- Install pg gem:
```
sudo su
env ARCHFLAGS="-arch x86_64" gem install pg -v '0.14.0'
```

### Application Setup

#### Database
- Initialize. ``initdb /usr/local/var/postgres -E utf8``
- Start. ``pg_ctl -D /usr/local/var/postgres -l logfile start``
- Connect and create a new user and database for the game:

```
psql -d postgres
CREATE USER dbuser WITH PASSWORD 'dbpass';
CREATE DATABASE socialnamegame;
GRANT ALL PRIVILEGES ON DATABASE socialnamegame TO dbuser;
```

#### Get the Code
- Clone the repository. ``git clone https://github.com/jmouel/socialnamegame.git``

#### Get App Dependencies
```bundle install```

#### Configure the App
- Copy the database config and modify as necessary if you're using your own database / username / password.
``cp config/database.yml.sample config/database.yml``
- Create your OAuth applications on Facebook, LinkedIn, Twitter, and Salesforce.
- Copy the sample settings and enter in the keys and secrets that you got from the social providers.
``cp config/settings.yml.sample config/settings.yml``

#### Create the Database Schema
``rake db:setup``

#### Start the App
``rails server``

Browse to <http://localhost:3000/> to start playing.


