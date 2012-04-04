require 'spec_helper' 

describe HomeController do
  describe "GET 'index'" do

    it "redirects to log the user in if they are not logged in" do
      get :index
      response.status.should be(302)
      response.redirect_url.should == login_url
    end

  end

  describe "GET 'printer'" do

    it "doesn't require authentication" do
      session[:user_id] = nil
      get :printer
      response.status.should be(200)
    end

    it "Renders scheduled printouts" do
      ScheduledPrints.any_instance.should_receive(:run)
      get :printer
    end

    it "should render a queued printout" do
      @printout = Factory :printout
      get :printer
      response.body.should == @printout.content
    end

    it "should not render a printout that has already been printed" do
      Printout.delete_all
      @printout = Factory :printout, :printed => true
      get :printer
      response.body.strip.should be_empty
    end

  end
end
