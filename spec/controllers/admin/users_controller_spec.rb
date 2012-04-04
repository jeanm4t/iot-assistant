require 'spec_helper'

describe Admin::UsersController do

  describe "the whole controller" do
    it "requires an admin user" do
      @user = Factory :user
      @user.update_attribute(:admin, false)
      session[:user_id] = @user.id
      get 'index'
      response.status.should == 302
      response.redirect_url.should == root_url
      flash[:alert].should include("not authorized")
      %w(login_as destroy).each do |action|
        post action
        response.status.should == 302
        response.redirect_url.should == root_url
        flash[:alert].should include("not authorized")
      end
    end
  end

  describe "when logged in as an admin" do 
    before :each do
      @admin = Factory :user, :admin => true
      session[:user_id] = @admin.id
    end

    describe "DELETE /users/:id" do
      it "should delete a user" do
        @user = Factory :user
        User.find(@user.id).should be
        delete 'destroy', :id => @user.id
        User.find_by_id(@user.id).should_not be
      end
    end

    describe "PUT /users/:id" do
      it "should update a user's attributes" do
        @user = Factory :user
        put 'update', :id => @user.id, :user => {:firstname => "David"}
        User.find(@user.id).firstname.should == "David"
      end
    end

    describe "POST /login_as/:id" do
      it "should swap the loged in user" do
        @user = Factory :user
        post 'login_as', :id => @user.id
        response.redirect_url.should == root_url
        flash[:notice].should include("now logged in as")
        session[:user_id].should == @user.id.to_s
      end
    end
  end

end
