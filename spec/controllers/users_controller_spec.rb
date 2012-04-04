require 'spec_helper'

describe UsersController do

  describe "changing settings" do

    before :each do
      @user = Factory :user
      session[:user_id] = @user
    end

    it "should update the users time zone" do
      put 'update', :time_zone => "Kyiv"
      User.find(@user.id).time_zone.should == "Kyiv"
    end

  end

end
