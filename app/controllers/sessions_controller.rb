class SessionsController < ApplicationController
  
  # Public: After a user has given the app permission to access their profile,
  # they will be returned here. Create a new user account if we have never
  # seen them before, otherwise just update some of their details.
  #
  # Raises an exception if the user creation fails for some reason (lazy).
  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_uid(auth["uid"])
    if user
      user.assign_attributes({name: auth["info"]["name"],
                             firstname: auth["info"]["first_name"],
                             surname: auth["info"]["last_name"],
                             image: auth["info"]["image"],
                             token: auth["credentials"]["token"],
                             refresh_token: auth["credentials"]["refresh_token"]}, :as => :admin)
      user.save
      session[:user_id] = user.id
      redirect_to root_url, notice: "Hello #{user.firstname}!"
    elsif APP_CONFIG[:signups_enabled]
      user = User.new
      user.assign_attributes({uid: auth["uid"],
                             name: auth["info"]["name"],
                             firstname: auth["info"]["first_name"],
                             surname: auth["info"]["last_name"],
                             email: auth["info"]["email"],
                             image: auth["info"]["image"],
                             token: auth["credentials"]["token"],
                             refresh_token: auth["credentials"]["refresh_token"],
                             expires_at: Time.at(auth["credentials"]["expires_at"])}, :as => :admin)
      if user.save
        session[:user_id] = user.id
        redirect_to root_url, notice: "Hello #{user.firstname}, nice to meet you!"
      else
        redirect_to login_path, notice: "Sorry, something went wrong"
      end
    else
      redirect_to login_path, alert: "Sorry, new users are disabled for this printer!"
    end
  end

  # Public: Returned here if the authentication fails.
  def failure
    redirect_to login_path, alert: "Sorry...something went wrong trying to authenticate you: #{params[:message]}"
  end

  # Public: Log out.
  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Bye!"
  end
end
