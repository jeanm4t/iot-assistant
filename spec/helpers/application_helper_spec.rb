require 'spec_helper'

describe ApplicationHelper do

  describe "fortune" do

    it "returns nothing if fortune is not available" do
      old_path = ENV["PATH"]
      ENV["PATH"] = ""
      helper.fortune.should_not be
      ENV["PATH"] = old_path
    end

    it "returns a fortune" do
      pending("Can't test fortune, fortune not installed") unless helper.which("fortune")
      helper.fortune.should be
    end

  end

  describe "recent stories on The Times" do
    
    before :each do
      stub_http_request(:get, times_rss).to_return(:body => fixture("times_rss.xml"))
    end

    it "requests The Times RSS feed" do
      helper.recent_stories
      a_request(:get, times_rss).should have_been_made.once
    end

    it "returns the number of stories requested" do
      stories = helper.recent_stories(5)
      stories.length.should == 5
    end

    it "returns an empty array if the request fails" do
      stub_http_request(:get, times_rss).to_return(:status => [500, "Error"])
      helper.recent_stories.should == []
    end

    it "returns the story titles" do
      helper.recent_stories(1).should == ["Pret to create 550 jobs with new outlets"]
    end

  end

end
