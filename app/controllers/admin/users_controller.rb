# Handles the viewing, editing, and deletion of users.
class Admin::UsersController < AdminController
  
  # Show all the users.
  def index
    page = params[:page] || 1
    @users = User.order("created_at DESC").page(page)
  end

  # Edit a user.
  def edit
    @user = User.find(params[:id])
  end

  # Update a user's attributes.
  def update
    @user = User.find(params[:id])
    @user.assign_attributes params[:user], :as => :admin
    if @user.save
      redirect_to admin_users_path, notice: "User updated"
    else
      redirect_to :back, alert: "There were some errors: #{@user.errors.full_messages.join(",")}"
    end
  end

  # Alter the session to emulate logging in as another user. A bit creepy but
  # useful for configuring rogue schedules and editing settings not possible
  # to edit as an admin (lazy DRY).
  def login_as
    session[:user_id] = params[:id]
    redirect_to root_url, notice: "OK master, you're now logged in as #{User.find(params[:id]).firstname}"
  end

  # Delete a user.
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path, notice: "Deleted user!"
  end
end
