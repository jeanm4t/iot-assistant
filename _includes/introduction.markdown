# Introduction
## What is it?

The Internet of Things Assistant is a Ruby on Rails application that can act as
a front-end for an [Adafruit Internet of Things Printer][adafruit]. It turns
your IoT Printer into a handy assistant that will print out snippets of
information you tell it to at a certain time each day, or on demand.

## Screenshots

A picture tells a thousand words.

<ul class="thumbnails">
  <li class="span3">
    <a class="thumbnail" href="img/screenshots/front.png"><img src="img/screenshots/front.png" alt="Front Page" ></a>
  </li>

  <li class="span3">
    <a class="thumbnail" href="img/screenshots/settings.png"><img src="img/screenshots/settings.png" alt="Settings page" ></a>
  </li>

  <li class="span3">
    <a class="thumbnail" href="img/screenshots/printouts.png"><img src="img/screenshots/printouts.png" alt="Printouts" ></a>
  </li>
</ul>
<ul class="thumbnails">
  <li class="span3">
    <a class="thumbnail" href="img/screenshots/users.png"><img src="img/screenshots/users.png" alt="Users" ></a>
  </li>

  <li class="span3">
    <a class="thumbnail" href="img/screenshots/printer.png"><img src="img/screenshots/printer.png" alt="Printer" ></a>
  </li>

  <li class="span3">
    <a class="thumbnail" href="http://instagr.am/p/H9UYnnDTbt/"><img src="http://distilleryimage5.s3.amazonaws.com/85372ea66a0311e180c9123138016265_7.jpg" alt="In the wild!" ></a>
  </li>
</ul>

## Features

 - Multi-user support. Any number of users can share one printer (for example a
   team in an office, or a family at home).
 - A web-based interface to pick what you want printed and when.
 - Scheduled-based printing; print once a day at the time you specify on the
   days you specify.
 - On-demand printing; print whenever you like at the touch of a button.
 - Administration interface for configuring your Assistant; e.g. disallowing
   new user creation and downloading the code for your Printer.
 - The application can be deployed on [Heroku](http://heroku.com) using the
   cedar stack.

In addition, the following 'modules' for the printouts are included by default:

 - Google Calendar daily agenda.
 - Unread email count + top 3 emails in your inbox.
 - A fortune cookie (if [fortune][] is installed).
 - Recent news stories from [The Times](http://thetimes.co.uk).
 - Latest tweets from your Twitter timeline.

[adafruit]: http://www.adafruit.com/products/717
[fortune]: https://en.wikipedia.org/wiki/Fortune_(Unix)
