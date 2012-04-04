# Public: Queues anything scheduled to be printed at the time of running
# (give or take a minute). 
class ScheduledPrints

  # Ew.
  class MyView < ActionView::Base
    include ActionView::Helpers
    # Brittle
    include ApplicationHelper
    include Rails.application.routes.url_helpers
  end

  def initialize
    @av = MyView.new(IotPrinterFront::Application.config.paths["app/views"].first)
  end

  def run
    # Find all users who haven't had a print out today.
    # Timezones make this a little...weird.
    @users = User.where("last_scheduled_print_at < ? OR last_scheduled_print_at IS NULL", Date.today.midnight)
    # Check + queue prints
    @users.each do |user|
      next unless user.schedule[:days] and user.schedule[:hour] and user.schedule[:min]
      
      # Set time zone
      old_time_zone = Time.zone
      Time.zone = user.time_zone
      now = Time.zone.now

      if user.schedule[:days].include?(Date.today.wday) and now.change(:hour => user.schedule[:hour], :min => user.schedule[:min]) <= now
        Rails.logger.info "#{Time.now} Printing for #{user.name}"
        
        # Set up Twitter
        Twitter.configure do |config|
          config.oauth_token = user.twitter_token
          config.oauth_token_secret = user.twitter_secret
        end

        if user.count_print_options == 0
          Rails.logger.info "#{Time.now} Well I would...but they don't want me to print anything"
        else
          user.printouts.create(content: @av.render(:template => "home/printer", :locals => {:user => user}))
        end
        user.last_scheduled_print_at = Time.now
        user.save
      end

      # Revert to original time zone
      Time.zone = old_time_zone
    end
  end

end
