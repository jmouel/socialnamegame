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
http://mxcl.github.com/homebrew/

#### PostgreSQL
Install PostgreSQL 9: ``brew install postgresql``

#### Ruby
- Install Ruby 1.9: ``brew install ruby``
- Override the standard Mac OS X install of Ruby by modifying the /etc/paths and moving the home-brews to the top of the file (/usr/local/bin), and also point /usr/bin/bundle at the new ruby interpreter location as well (first line). Or use rvm or rbenv.
- Install bundler: ``sudo gem install bundler``
- Install pg gem:
```
sudo su
env ARCHFLAGS="-arch x86_64" gem install pg -v '0.14.0'
```

### Application Setup

#### Database
- Initialize: ``initdb /usr/local/var/postgres -E utf8``
- Start: ``pg_ctl -D /usr/local/var/postgres -l logfile start``
- Connect and create a new user and database for the game:

```
psql -d postgres
CREATE USER dbuser WITH PASSWORD 'dbpass';
CREATE DATABASE socialnamegame;
GRANT ALL PRIVILEGES ON DATABASE socialnamegame TO dbuser;
```

#### Get the Code
Clone the repository. ``git clone https://github.com/jmouel/socialnamegame.git``

#### Get App Dependencies
```bundle install```

#### Configure the Database Connection
Copy the database config and modify as necessary if you're using a different database, user, etc.
``cp config/database.yml.sample config/database.yml``

#### Create the Database Schema
``rake db:setup``

### Social Provider Setup

Socialnamegame uses OAuth to authenticate users to the 4 supported social data providers. For each, you must create an "Application" (the shared
secret between the provider and your server) and configure socialnamegame to use it.

#### Prepare Configuration
``cp config/settings.yml.sample config/settings.yml``
- Your OAuth settings for each provider will go into _config/settings.yml_.

#### Twitter
- Visit <https://dev.twitter.com> and create a new application.
- For the _Callback URL_, use _http://localhost:3000/auth/twitter/callback_.
- Copy the Consumer Key and Consumer Secret from Twitter into the _twitter_ _key:_ and _secret:_ fields in _settings.yml_.

#### LinkedIn

- Go to <https://www.linkedin.com/secure/developer> and add an application.
- Copy the API Key and Secret Key from LinkedIn into the _linkedin_ _key:_ and _secret:_ fields in _settings.yml_.

#### Facebook

- Create a new app at <http://facebook.com/developers>.
- Set the _Site URL_ field to _http://localhost:3000/_.
- Copy the Consumer Key and Consumer Secret from Facebook into the _facebook_ _key:_ and _secret:_ fields in _settings.yml_.

#### Salesforce

- Go to App Setup > Develop > Remote Access and create a new Remote Access Application.
- Set the _Callback URL_ to _http://localhost:3000/auth/salesforce/callback_.
-- Note that you will need to use an HTTPS callback URL if you deploy the app somewhere other than your local machine.
- Copy the Consumer Key and Consumer Secret from Salesforce into the _salesforce_ _key:_ and _secret:_ fields in _settings.yml_.

#### SSL
The code in Github is identical to what is deployed to Heroku on www.socialnamegame.com. SSL is required in that environment, so http requests are redirected automatically.
In your local environment, you can disable the redirect by modifying the ApplicationController and commenting out this line:

``before_filter :redirect_https``

### Start the App
``rails server``

Browse to <http://localhost:3000/> to start playing.

FAQ
---
#### Why does your _________ (code/architecture/approach/ux/ui/hairdo) suck so much?
This project exists to share the sample code I presented in a Dreamforce session. It's not a production-quality app. If you have improvements, feel free to create a pull request and I'll review it.

#### Why does the app suck hard in ________ (Firefox/IE/Opera/mobile device)?
I only had time to test on Chrome. See above.

#### Can I play the game without following all of these gosh darn instructions?
Yes. Visit <https://www.socialnamegame.com>. It's hosted on Heroku.

#### Why should I trust your silly app with my precious social data?
Well you can read the code. I'm not doing anything sneaky. And if you don't trust the Heroku-hosted version, don't use it. You can also click Delete Account to remove your social data and authentication token.

#### Why aren't there instructions for _________ (Windows/Linux/OS2/BeOS/AmigaOS)?
I primarily use a Mac. If you want to write instructions for another OS, I'll add them to this readme.

#### Why did you use ________ (CoffeeScript/Saas)? I like __________ (JavaScript/CSS).
Personal preference. You can always view the source to see the raw JS/CSS, which is extremely readable.

#### Why didn't you use __________ (Backbone.js/framework*,push)?
Tried to keep the number of technologies unrelated to social to a minimum.

#### Why do you only load 500 contacts? I'm really popular so I have _________ (> 500) contacts and want to use them in the game.
Heroku limits requests to 30 seconds, the app is hosted on Heroku, and a lot of social APIs are slow. 
An alternative is to load more contacts incrementally, per user web request, but I ran out of time/energy. The easiest solution is to import contacts asynchronously. See below.

#### Why didn't you use _________ (resque/sidekiq/other async gem) to import the social contacts in the background?
Because Heroku workers cost money and I'm a poor, starving startup founder. The worker classes are actually written to use Sidekiq, so if you are feeling wealthy or want to run async workers locally, you can do so.

#### Why do you have a separate table for authentications instead of denormalizing to place them in the User table?
Originally I thought the game would merge all of the providers into one big game database per user. So a single user record would contain up to 4 authentications, one per provider. 
But the data quality (images, names) varies so much between provider that it turns out to be a better idea to keep them separate,
for the sake of good gameplay. Also, the game is plenty hard enough without the added dimension of varied providers.
