require 'spec_helper'

describe "The home page" do

  before :each do
    APP_CONFIG[:signups_enabled] = true
    User.destroy_all
  end

  describe "with signups enabled" do
    it "should let a new user log in" do
      visit login_path
      mock_auth_hash
      click_link "Login"
      page.should have_content("Log out")
    end
  end

  describe "without signups enabled" do
    it "shouldn't let a new user log in" do
      APP_CONFIG[:signups_enabled] = false
      visit login_path
      mock_auth_hash
      click_link "Login"
      page.should have_content("Log in")
    end

    it "should still let an existing user log in" do
      @user = Factory :user
      mock_auth_hash(@user.uid)
      visit login_path
      click_link "Login"
      page.should have_content("Log out")
    end
  end

  describe "when logged in" do
    before :each do
      visit login_path
      mock_auth_hash
      click_link "Login"
      @user = User.find_by_uid('123545')
    end

    it "should show the scheduled print time" do
      visit root_path
      page.should have_content("#{"%02d" % @user.schedule[:hour]}:#{"%02d" % @user.schedule[:min]}")
    end

    it "should show the user's profile image" do
      visit root_path
      page.should have_css('img', :src => @user.image)
    end

    it "should let you preview the printout" do
      visit root_path
      # Stub all requests to return errors
      stub_request(:any, //).
        to_return(:status => 404, :body => "", :headers => {})
      click_link "Show me a preview"
    end
  end

end
