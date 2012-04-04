require 'spec_helper'

describe Admin::HomeController do

  before :each do
    # Keep these this way round; user model will try to make first user an
    # admin.
    @admin = Factory :user, :admin => true
    @user = Factory :user, :admin => false
  end

  %w(index settings printer printer_file).each do |action| 
    describe "GET '#{action}'" do
      it "asks the user to log in if they are not logged in" do
        get action
        response.status.should == 302
        response.redirect_url.should == login_url
      end

      it "requires a user to be an admin" do
        @user.admin.should_not be
        session[:user_id] = @user.id
        get action
        response.status.should == 302
        flash[:alert].should include("authorized")
      end

      it "permits an admin to view" do
        # printer_file redirects.
        unless action == "printer_file"
          session[:user_id] = @admin.id
          get action
          response.status.should == 200
        end
      end

    end
  end

  describe "printer_file" do

    before :each do
      session[:user_id] = @admin.id
      @params = {:mac => "de:ad:be:ef:de:ad", :ip => "192.168.0.1", :server => "localhost", :url => "/test"}
      request.env["HTTP_REFERER"] = "http://localhost/"
    end

    it "rejects invalid MAC addresses" do
      get "printer_file", @params.merge({:mac => "in:va:lid"})
      response.status.should == 302
      flash[:alert].should include("specify a valid MAC address")
    end

    it "rejects invalid IP addresses" do
      get "printer_file", @params.merge({:ip => "as.df"})
      response.status.should == 302
      flash[:alert].should include("specify a valid IP address")
    end

    it "requires a server and url" do
      get "printer_file", {:mac => "de:ad:be:ef:de:ad", :ip => "192.168.0.1"}
      response.status.should == 302
      flash[:alert].should include("specify a server and URL")

      get "printer_file", {:mac => "de:ad:be:ef:de:ad", :ip => "192.168.0.1", :server => "test"}
      response.status.should == 302
      flash[:alert].should include("specify a server and URL")

      get "printer_file", {:mac => "de:ad:be:ef:de:ad", :ip => "192.168.0.1", :url => "test"}
      response.status.should == 302
      flash[:alert].should include("specify a server and URL")
    end

    # TODO: this should be pulled out into a request/view spec.
    describe "the file itself" do
      render_views

      it "constructs a MAC address in the valid format in the source" do
        get "printer_file", @params
        response.body.should include("0xDE, 0xAD, 0xBE, 0xEF, 0xDE, 0xAD")
      end

    end

  end

end
