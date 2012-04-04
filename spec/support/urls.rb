def calendar_events(id=nil)
  if id
    "https://www.googleapis.com/calendar/v3/calendars/#{id}/events" 
  else
    /https:\/\/www\.googleapis\.com\/calendar\/v3\/calendars\/.*\/events/
  end
end

def mail_summary
  "https://mail.google.com/mail/feed/atom"
end

def times_rss
  "http://www.thetimes.co.uk/tto/news/rss"
end
