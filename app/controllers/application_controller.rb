class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :twitter_configured?, :admin?

  around_filter :set_user_time_zone

  private
  # Public: Redirect the user if they are not logged in. Also set up Twitter
  # if they are logged in.
  def authorized!
    redirect_to login_path, alert: "You must be logged in to view that!" and return unless current_user
    unless current_user.refresh_token
      redirect_to login_path, alert: "Missing token, please log in again." 
      session[:user_id] = nil
      return
    end

    Twitter.configure do |config|
      config.oauth_token = current_user.twitter_token
      config.oauth_token_secret = current_user.twitter_secret
    end
  end

  # Public: Redirect the user if they are not an admin.
  # Assumes that a user is logged in (use after :authorized!)
  #
  # Halts rendering.
  def admin!
    redirect_to root_path, alert: "You are not authorized to view that!" and return unless current_user.admin
  end

  # Public: returns the current logged in user (if there is one).
  # Unsets the session variable if there isn't. This stops users that have
  # been deleting from seeing an error page when they next visit.
  #
  # Returns the currently logged in user model.
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound => e
    session[:user_id] = nil
  end

  # Public: Is the user (if any) an admin?
  def admin?
    current_user and current_user.admin
  end

  # Public: Check the application configuration to see if Twitter has been
  # configured (e.g. oAuth tokens have been provided)
  #
  # Returns: true or false, depending on the necessary configuration has
  # been set.
  def twitter_configured?
    Twitter.consumer_key and Twitter.consumer_secret
  end

  # Public: Use as part of an around_filter to set the users time-zone for
  # the duration of their request, and then unset it for the next request
  # (recommended practice though I don't know if it causes problems leaving
  # it out).
  def set_user_time_zone
    old_time_zone = Time.zone
    Time.zone = current_user.time_zone if current_user
    yield
  ensure
    Time.zone = old_time_zone
  end

end
