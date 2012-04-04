class PrintoutsController < ApplicationController
  before_filter :authorized!
  
  # Public: list printouts.
  def index
    page = params[:page] || 1
    @printouts = Printout.order("created_at DESC").page(page)
  end

  # Public: Delete a printout
  def destroy
    printout = current_user.printouts.find(params[:id])
    if printout
      printout.destroy
      redirect_to printouts_path, notice: "Printout deleted"
    else
      redirect_to printouts_path, alert: "Sorry, something went wrong"
    end
  end

  def show
    printout = current_user.printouts.find params[:id]
    if printout
      render :text => printout.content, :content_type => Mime::TEXT, :layout => false
    else
      render :status => 404, :text => "Not Found"
    end
  end
end
