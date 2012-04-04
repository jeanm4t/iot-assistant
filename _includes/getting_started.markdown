# Getting Started

## Requirements

 - Ruby 1.9
 - Rubygems
 - SQL database (tested with PostgreSQL)
 - [Bundler](http://gembundler.com/)

If deploying to Heroku, you do not need these things set up locally.

## Get the code

All the code is available on [Github][], you can download a copy using git:

    git clone git://github.com/newsinternational/iot-assistant

## Configuration

Configuration is done through `config/config.yml` which by default uses
environment variables (which is suitable for deployment to Heroku). You can
change `config.yml` for your set-up, but we advise using environment variables
if possible as then there is no risk of revealing API keys etc. in the source
code. The available environment variables are listed below.

<table class="table table-bordered table-striped">
  <thead>
    <tr>
      <th>Variable</th>
      <th>Description</th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td><code>GOOGLE_CLIENT_ID</code></td>
      <td>Your application's Google OAuth 2.0 Client ID. See the 'Google'
      section below for more information.</td>
    </tr>
    <tr>
      <td><code>GOOGLE_CLIENT_SECRET</code></td>
      <td>Your application's Google OAuth 2.0 Client Secret. See the 'Google'
      section below for more information.</td>
    </tr>
    <tr>
      <td><code>TWITTER_CONSUMER_KEY</code></td>
      <td>Optional. Your application's Twitter Consumer Key. See the 'Twitter'
      section below for more information.</td>
    </tr>
    <tr>
      <td><code>TWITTER_CONSUMER_SECRET</code></td>
      <td>Optional. Your application's Twitter Consumer Secret. See the
      'Twitter' section below for more information.</td>
    </tr>
    <tr>
      <td><code>SIGNUPS_ENABLED</code></td>
      <td>Whether to allow new user signups or not. Default is true.</td>
    </tr>
    <tr>
      <td><code>PRINTER_KEY</code></td>
      <td>A secret unique string (valid in a URL) that makes up part of the URL
      the IoT Printer itself polls to check for printouts. This is a simple
      security through obscurity to avoid others scraping your printouts.</td>
    </tr>
  </tbody>
</table>

### Google

IoT Assistant requires a set of Google API keys for authentication, and
accessing the user's calendar and email. In the future these may be optional,
but as these are core features of the printout Google API access is required,
and as such it is also used for logging in to the application.

For more information about using OAuth 2.0 to access Google APIs, have a look
at [Google's documentation][google oauth]. In short, create an application
using the [Google API console][google console] and copy the client ID and secret. The callback
URL should be set based on where you are going to deploy the IoT assistant, for
example:

    http://my-iot-assistant.herokuapp.com/auth/google/callback

Also **ensure the application has access to the calendar API**, this can be
switched on in the 'Services' section of the Google API console for the
application.

### Twitter

You can optionally configure IoT Assistant with a set of Twitter OAuth keys
so that users can opt to have their printout include recent tweets from people
they follow. You can get a set of these from the [Twitter Developer site][twitter].

## Deployment

### On Heroku

You need a Heroku account in order to deploy to [Heroku](http://heroku.com).
It's free to sign up.

1. Having cloned down a copy of the code and obtained all the necessary 
   API credentials, change into the directory the code resides in.

2. Install the [Heroku toolbelt](https://toolbelt.heroku.com/).

3. Create a new Heroku app (pick a unique name), remember to pick the [Cedar
   stack](http://devcenter.heroku.com/articles/cedar):

       $ heroku apps:create davids-iot-assistant --stack cedar
       Creating davids-iot-assistant... done, stack is cedar
       http://davids-iot-assistant.herokuapp.com/ | git@heroku.com:davids-iot-assistant.git
       Git remote heroku added
       $ 

4. Give Heroku your API keys and configuration. Here's a complete example set:

       $ heroku config:add \
       > GOOGLE_CLIENT_ID="1234.apps.googleusercontent.com" \
       > GOOGLE_CLIENT_SECRET="DPk7lQsWS1CrzaMuVfD" \
       > TWITTER_CONSUMER_KEY="Yn3pPCweFENRmku6AABgY" \
       > TWITTER_CONSUMER_SECRET="PioxXkHoHRb2bCIwRecx0SaED" \
       > SIGNUPS_ENABLED=true \
       > PRINTER_KEY=asf324tdsf2
       Adding config vars and restarting app... done, v2
       GOOGLE_CLIENT_ID        => 1234.apps.googleusercontent.com
       GOOGLE_CLIENT_SECRET    => DPk7lQsWS1CrzaMuVfD
       TWITTER_CONSUMER_KEY    => Yn3pPCweFENRmku6AABgY
       TWITTER_CONSUMER_SECRET => PioxXkHoHRb2bCIwRecx0SaED
       SIGNUPS_ENABLED         => true
       PRINTER_KEY             => asf324tdsf2
       $  

5. Now push the code to Heroku:

       $ git push heroku master
       Counting objects: 7, done.
       Delta compression using up to 4 threads.
       Compressing objects: 100% (4/4), done.
       Writing objects: 100% (4/4), 379 bytes, done.
       Total 4 (delta 3), reused 0 (delta 0)
       
       -----> Heroku receiving push
       <snip>
       -----> Compiled slug size is 20.6MB
       -----> Launching... done, v3
              http://davids-iot-assistant.herokuapp.com deployed to Heroku
       $

6. Set up the Heroku database:

       $ heroku run rake db:setup
       Running rake db:setup attached to terminal... up, run.1

       -- create_table("printouts", {:force=>true})
          -> 0.1443s
       -- create_table("users", {:force=>true})
          -> 0.0780s
       -- initialize_schema_migrations_table()
          -> 0.0009s
       -- assume_migrated_upto_version(20120402101359, ["/app/db/migrate"])
          -> 0.0014s
       $

7. You're done! Now go visit your Heroku app (whatever name you gave it) and
   log in. **The first user that logs in will be the first admin user**.



[github]: https://github.com/newsinternational/iot-assistant
[google oauth]: https://developers.google.com/accounts/docs/OAuth2
[google console]: https://code.google.com/apis/console/
[twitter]: http://dev.twitter.com/apps
