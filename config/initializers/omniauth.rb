Rails.application.config.middleware.use OmniAuth::Builder do
  # If you don't need a refresh token -- if you're only using Google for account creation/auth and don't need google services -- set the access_type to 'online'.
  # Also, set the approval prompt to an empty string, since otherwise it will be set to 'force', which makes users manually approve to the Oauth every time they log in.
  # See http://googleappsdeveloper.blogspot.com/2011/10/upcoming-changes-to-oauth-20-endpoint.html

  provider :google_oauth2, APP_CONFIG[:google][:client_id], APP_CONFIG[:google][:client_secret], {access_type: 'offline', approval_prompt: 'force', scope: "userinfo.email https://mail.google.com/mail/feed/atom https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/calendar.readonly", name: "google"}

  provider :twitter, "EfQ1dCWqMXnLXNWGtqyvgg", "y7s6gWcaDBhsvvNPm93pJndnFRskqZT81Qy91tGiSQ"
end
