class User < ActiveRecord::Base
  has_many :printouts, :dependent => :destroy

  store :schedule

  serialize :calendars

  validates :uid, :uniqueness => true

  validates :refresh_token, :expires_at, :presence => true

  validates :firstname, :time_zone, :presence => true

  before_save   :check_twitter_option
  before_create :set_default_schedule, :empty_calendars, :first_admin

  attr_accessible :image, :name, :firstname, :surname, :schedule,
    :calendars, :print_calendar, :print_email, :print_qotd, :print_stories,
    :print_twitter_timeline, :time_zone

  attr_accessible :image, :name, :firstname, :surname, :schedule,
    :calendars, :print_calendar, :print_email, :print_qotd, :print_stories,
    :print_twitter_timeline, :time_zone, :as => [:admin, :default]
  attr_accessible :uid, :token, :email, :admin, :twitter_token,
    :twitter_secret, :last_scheduled_print_at, :twitter_username,
    :refresh_token, :expires_at, :as => :admin

  # Public: Returns a list of the user's calendars in Google Calendar. See
  # <https://developers.google.com/google-apps/calendar/v3/reference/calendarList/list>
  # for more information.
  #
  # Returns an array of calendarList Resources (as Hashie Mashes)
  def remote_calendars
    return @remote_calendars if @remote_calendars
    response = google_request("https://www.googleapis.com/calendar/v3/users/me/calendarList")
    if response.success?
      @remote_calendars = Hashie::Mash.new(JSON.parse(response.body)).items
    else
      false
    end
  end

  # Public: Today's agenda from Google calendar
  #
  # Returns an array of Hashie::Mashes
  def todays_agenda
    agenda(Time.now.midnight.iso8601, Date.tomorrow.midnight.iso8601)
  end

  # Public: Agenda between two points in time, across all the user's calendars.
  # See <https://developers.google.com/google-apps/calendar/v3/reference/events/list>
  # for more information.
  #
  # Items are sorted based on their start date. All day events come first,
  # ahead of any other dates (this makes them appear at the top of the agenda
  # when printed).
  #
  # min - ISO8601 date string
  # max - ISO8601 date string
  #
  # Returns an array of events as Hashie Mashes, or false if something went
  # wrong.
  def agenda(min, max)
    return false unless self.calendars
    events = []
    self.calendars.each do |id, summary|
      response = google_request("https://www.googleapis.com/calendar/v3/calendars/#{id}/events", :params => {"orderBy" => "startTime", "maxResults" => 10, "singleEvents" => true, "timeMin" => min || nil, "timeMax" => max || nil}) 
      if response.success?
        (Hashie::Mash.new(JSON.parse(response.body))["items"] || []).each do |item|
          item[:calendar] = summary
          events << item
        end
      else
        false
      end
    end
    events.uniq{|a| a.id}.sort{|a,b|
      if !b.start.dateTime
        1
      elsif !a.start.dateTime || Time.parse(a.start.dateTime) < Time.parse(b.start.dateTime)
        -1
      else
        1
      end
    }
  rescue JSON::ParserError => e
    Rails.logger.warn "Tried to fetch an agenda but received invalid JSON"
    return false
  end

  # Public: Fetch the user's emails
  #
  # Returns Nokogiri document or false if the request failed.
  def mail_summary
    return @mail_summary if @mail_summary
    response = google_request("https://mail.google.com/mail/feed/atom")
    if response.success?
      @mail_summary = Nokogiri::XML(response.body)
    else
      return false
    end
  end

  # Public: Using the mail summary, work out how many emails are unread.
  #
  # Returns the number of unread emails in the user's inbox (Integer)
  def unread_mail_count
    mail_summary.at("fullcount").text.to_i
  end

  # Public: Fetch the emails in the user's mail summary
  #
  # Returns an array of Nokogiri XML elements.
  def unread_emails
    mail_summary.search("entry")
  end

  # Public: Count the number of print options selected.
  #
  # Returns the number of print options selected (integer).
  def count_print_options
    self.class.print_options.count do |c|
      self[c]
    end
  end

  def self.print_options
    column_names.select{|p| p.starts_with? "print_"}
  end
  
  private
  # Private: Force no twitter timeline if no twitter creds
  def check_twitter_option
    self.print_twitter_timeline = false unless self.twitter_token
    true
  end

  # Private: Perform an authenticated Google API request on behalf of the user.
  # Attempts to obtain a new access token if the current one has expired, but
  # if the attempt fails, so will the API request.
  #
  # url - request URL.
  # options - Hash of options to pass to Typhoeus.
  #
  # Returns the Typhoeus::Response object corresponding to the request.
  def google_request(url, options={})
    
    if self.expires_at <= Time.now
      get_new_access_token
    end
    options[:headers] ||= {}
    options[:headers][:Authorization] = "OAuth #{self.token}"
    Typhoeus::Request.get(url, options)
  end

  # Private: Get a new access token for the user. This is part of the OAuth 2
  # specification and involves using the user's refresh token to request a new
  # access token from Google. This new token is accompanied by a new expiry time.
  #
  # If the attempt fails, nothing happens; subsequent API requests will still
  # potentially fail, so be warned. This method does not attempt to retry the
  # request, as it is possible the application's access has been revoked by
  # the user. API requests following a failed refresh will return invalid
  # authentication responses.
  #
  # Returns the user's 'new' access token.
  def get_new_access_token
    response = Typhoeus::Request.post("https://accounts.google.com/o/oauth2/token",
      :params => {
        "client_id" => APP_CONFIG[:google][:client_id],
        "client_secret" => APP_CONFIG[:google][:client_secret],
        "refresh_token" => self.refresh_token,
        "grant_type" => "refresh_token"
    })

    if response.success?
      token_json = Hashie::Mash.new(JSON.parse(response.body))
      expires_at = Time.now + token_json.expires_in
      self.assign_attributes({token: token_json.access_token,
                              expires_at: expires_at}, :as => :admin)
      self.save
    end

    return self.token
  end


  # Private: Set a users default schedule. Unless you want to run the risk of a
  # lot of unexpected printouts, this should have an empty array for days of
  # the week.
  #
  # Returns nothing in particular.
  def set_default_schedule
    self.schedule[:days] = []
    self.schedule[:hour] = 9
    self.schedule[:min] = 00
  end

  def empty_calendars
    self.calendars ||= {}
  end
  
  # Private: If there are no users yet, make this new user an admin.
  def first_admin
    if User.count == 0
      self.admin = true
    end
  end

end
