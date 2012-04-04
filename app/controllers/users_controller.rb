class UsersController < ApplicationController

  before_filter :authorized!

  def twitter_callback
    auth = request.env["omniauth.auth"]
    current_user.update_attributes twitter_username: auth["info"]["nickname"],
                                   twitter_token: auth["credentials"]["token"],
                                   twitter_secret: auth["credentials"]["secret"]
    redirect_to :user_settings, :notice => "Your Twitter account is now connected!"
  end

  def destroy_twitter
    current_user.update_attributes twitter_username: nil,
                                   twitter_token: nil,
                                   twitter_secret: nil
    redirect_to :user_settings, :notice => "Your Twitter account is no longer connected"
  end

  def settings  
  end

  def update

    attrs = {}
    User.print_options.each{|option|
      attrs[option] = params[option] ? true : false
    }

    current_user.update_attributes attrs

    current_schedule = current_user.schedule

    current_user.schedule[:days] = params[:dow] ? params[:dow].map{|k,v| k.to_i} : []
    current_user.schedule[:hour] = params[:hour].to_i 
    current_user.schedule[:min] = params[:min].to_i 

    current_user.time_zone = params[:time_zone]

    if current_user.schedule != current_schedule
      current_user.last_scheduled_print_at = Date.yesterday.midnight
    end

    current_user.calendars = params[:calendars] || {}

    current_user.save

    redirect_to :user_settings, :notice => "Settings updated #{current_user.firstname}. Thank you!" 
  end

  def destroy
    current_user.destroy
    session[:user_id] = nil
    redirect_to login_path, :notice => "Your account has been deleted!"
  end

end
