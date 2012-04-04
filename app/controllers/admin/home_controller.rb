class Admin::HomeController < AdminController

  def index
  end

  def settings
  end

  def printer
  end

  def printer_file
    @mac = (params[:mac] || "").split(":")
    redirect_to :back, :alert => "Please specify a valid MAC address" and return unless @mac.length == 6
    @ip = (params[:ip] || "127.0.0.1").split "."
    redirect_to :back, :alert => "Please specify a valid IP address" and return unless @ip.length == 4
    @server = params[:server]
    @url = params[:url]
    redirect_to :back, :alert => "Please specify a server and URL" and return unless @server and @url

    send_data(render_to_string("iot_printer_remote.ino", :layout => false), :disposition => "attachment; filename=iot_printer_remote.ino")
  end
end
