class AdminController < ApplicationController
  before_filter :authorized!
  before_filter :admin!
end
