class HomeController < ApplicationController
  before_filter :authorized!, :except => [:printer, :login]

  # Public: Front page has some buttons for actions and statistics, not a lot
  # else.
  def index
    @total = Printout.count
    @to_print = Printout.where(printed: false).count
  end

  # Public: Creates a new printout based on the users settings.
  def print
    if current_user.count_print_options == 0
      redirect_to root_path, :alert => "Specify that you want something to print!" and return
    end
    printout = current_user.printouts.create(content: render_to_string("home/printer.erb", :layout => false, :locals => {:user => current_user}))
    printout.save!
    redirect_to root_path, :notice => "Your printout has been queued!"
  end
  
  # Public: Show the user what their printout might look like (ish).
  def print_debug
    render "home/printer", :locals => {:user => current_user}, :content_type => Mime::TEXT, :layout => false
  end

  # Public: Endpoint the printer hits. Gives the printer a printout (if one
  # exists) and assumes the printer successfully printed it.
  def printer
    # Check for scheduled prints
    ScheduledPrints.new.run

    printout = Printout.where(printed: false).first
    if printout
      printout.update_attribute(:printed, true)
      render :text => printout.content
    else
      render :nothing => true
    end
  end

  # Public: Login page. Log the user in automatically if they are offline +
  # developing.
  def login
    if ENV["OFFLINE"] == "true" and Rails.env == "development"
      session[:user_id] = User.first.id
      redirect_to root_path
    end
  end
end
