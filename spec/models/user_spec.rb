require_relative '../spec_helper'

describe User do

  before :each do
    @user = Factory(:user, :calendars => {"example1" => "first calendar", "example2" => "second calendar"})
    @hydra = Typhoeus::Hydra.hydra
  end

  describe "fetching calendars" do 
    it "should fetch the user's selected calendars" do
      stub_http_request(:get, calendar_events).to_return(
        :body => {:items => []}.to_json
      )
      @user.todays_agenda
      @user.calendars.each do |calendar, summary|
        a_request(:get, calendar_events(calendar)).with(:query => hash_including({})).should have_been_made.once
      end
    end

    it "should handle an invalid response for calendars" do
      stub_http_request(:get, calendar_events).to_return(
        :body => "Invalid response"
      )
      @user.todays_agenda.should eq(false)
    end

    it "should return an array of events" do
      # Minimum requirements for the function to run
      response = {
        :items => [
          {:start => {:date => "2012-01-01"}, :id => 1},
          {:start => {:date => "2012-01-01"}, :id => 2}
        ]
      }
      stub_http_request(:get, calendar_events).to_return(:body => response.to_json)
      @user.todays_agenda.length.should eq(response[:items].length)
    end

    it "should filter out non-unique events" do
      response = {
        :items => [
          {:start => {:date => "2012-01-01"}, :id => 1},
          {:start => {:date => "2012-01-01"}, :id => 1}
        ]
      }
      stub_http_request(:get, calendar_events).to_return(:body => response.to_json)
      @user.todays_agenda.length.should eq(1)
    end

    it "should return false if the user has no calendars" do
      @user.calendars = nil
      @user.todays_agenda.should be_false
    end
  end

  describe "fetching email summary" do
    before :each do
      stub_http_request(:get, mail_summary).to_return(:body => fixture("mail_summary.xml"))
    end

    it "should fetch the user's mail feed and return a document" do
      @user.mail_summary.should be_a Nokogiri::XML::Document
      a_request(:get, mail_summary).should have_been_made.once
    end

    it "should handle failed requests" do
      stub_http_request(:get, mail_summary).to_return(:status => [500, "Whoops"])
      @user.mail_summary.should be_false
    end

    it "should return the correct unread mail count" do
      @user.unread_mail_count.should eq(1)
    end

    it "should return an array of unread emails" do
      @user.unread_emails.length.should eq(1)
    end
  end

  describe "admin users" do
    it "should automatically make the first user an admin user" do
      User.delete_all
      @user = Factory :user
      @user.save
      @user.admin.should be
    end

    it "should not make any other users admins by default" do
      User.delete_all
      user = Factory :user
      user.admin.should be
      user_two = Factory :user
      user_two.admin.should_not be
    end
      
  end

end
