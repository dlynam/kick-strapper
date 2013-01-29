class Admin::AuthenticateController < Admin::AdminController
  before_filter :admin_check, :only => [ :console ]
  layout "admin"

  def index
  end

  def console
  end

  def verify
   md5 = Digest::MD5.new
   md5 << params[:password]
   if md5.hexdigest == "643031f044b3f58f2bd901c8fcdf46ab"
     session[:admin] = true
     redirect_to console_admin_authenticate_index_path
   else
     flash[:notice] = "Incorrect password"
     redirect_to :controller => 'authenticate', :action => 'index'
   end
  end

  def logout
   session[:admin] = nil
   flash[:notice] = "You have been logged out."
   redirect_to root_path
  end

end