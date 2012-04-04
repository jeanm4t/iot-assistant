module OmniauthMacros
  def mock_auth_hash(uid='123545')
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:google] = {
      'provider' => 'google_oauth2',
      'uid' => uid,
      'info' => {
        'name' => 'mockuser',
        'first_name' => 'mock',
        'last_name' => 'user',
        'image' => 'mock_user_thumbnail_url',
        'email' => 'test@example.com'
      },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret',
        'refresh_token' => 'mock_refresh',
        'expires_at' => (Time.now + 86400).to_i
      }
    }
  end

  def mock_twitter_hash
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:twitter] = {
      'provider' => 'twitter',
      'uid' => '123454',
      'info' => {
        'nickname' => 'twitter_user',
        'name' => 'Twitter User',
        'image' => 'mock_user_thumbnail_url'
      },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      }
    }
  end
end
