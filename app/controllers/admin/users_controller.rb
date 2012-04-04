class Admin::UsersController < AdminController
  def index
    page = params[:page] || 1
    @users = User.order("created_at DESC").page(page)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to admin_users_path, notice: "User updated"
    else
      redirect_to :back, alert: "There were some errors: #{@user.errors.full_messages.join(",")}"
    end
  end

  def login_as
    session[:user_id] = params[:id]
    redirect_to root_url, notice: "OK master, you're now logged in as #{User.find(params[:id]).firstname}"
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path, notice: "Deleted user!"
  end
end
