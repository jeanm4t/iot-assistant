if APP_CONFIG[:twitter].is_a?(Hash)
  if [:key, :secret].all?{|k| APP_CONFIG[:twitter].include? k }
    Twitter.configure do |config|
      config.consumer_key = APP_CONFIG[:twitter][:key]
      config.consumer_secret = APP_CONFIG[:twitter][:secret]
    end
  else
    Rails.logger.warn "Warning: You have configured your Twitter credentials incorrectly, please include your :key and :secret. You can get these from http://dev.twitter.com/apps" 
  end
end
