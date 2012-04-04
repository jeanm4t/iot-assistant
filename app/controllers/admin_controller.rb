# Root Admin controller. Namespaced controller should inherit from this
# controller to require admin credentials.
class AdminController < ApplicationController
  before_filter :authorized!
  before_filter :admin!
end
