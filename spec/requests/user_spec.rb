require 'spec_helper'

describe "Users" do

  before :each do
    User.destroy_all
    @user = Factory :user
    
    # Stub out calendar fetch with an error response.
    stub_request(:get, "https://www.googleapis.com/calendar/v3/users/me/calendarList").
      with(:headers => {'Authorization'=>'OAuth mock_token'}).
      to_return(:status => 500, :body => "{}", :headers => {})
  end

  it "should be able to auth with Twitter" do
    visit login_path
    mock_auth_hash(@user.uid)
    click_link "Login"
    click_link "Settings"
    page.should have_content("Connect to Twitter")
    twitter_hash = mock_twitter_hash
    click_link "Connect to Twitter"
    page.should have_content("Your Twitter account is now connected!")
    User.find(@user.id).twitter_username.should == twitter_hash["info"]["nickname"]
  end

end
