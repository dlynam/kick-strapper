class ApplicationController < ActionController::Base
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :check_authorization
  before_filter :save_referer
  
  include LoginSystem

  def check_authorization
    authorization_token = cookies[:authorization_token]
    if authorization_token && !is_logged_in?
      user = User.find_by_authorization_token(authorization_token)
      self.logged_in_user = user if user
    end
  end

  def save_referer
    unless is_logged_in?
      unless session[:referer]
        session[:referer] = request.env["HTTP_REFERER"] || 'none'
      end
    end
  end

  def already_logged_in?
    if is_logged_in?
      flash[:notice] = "You are already logged in."
      redirect_to root_path
    end
  end

  def parse_facebook_cookies
    Koala::HTTPService.http_options[:ssl] = {:ca_file => '/etc/ssl/certs/ca-bundle.crt'} #http://certifie.com/ca-bundle/ca-bundle.crt.txt
    #@fb_cookies = Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
    #raise @fb_cookies.inspect
    begin  #hackish way to check for expired tokens
      @fb_cookies = Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
      if @fb_cookies
        if is_logged_in?
          @fb_cookies  = nil if @logged_in_user.fb_user_id.nil? || @logged_in_user.fb_user_id != @fb_cookies['user_id']
        else
          #need to clear facebook cookies here
        end
      end
    rescue
      @fb_cookies = nil
    end
  end

  protected

  def admin_check
    x = session[:admin]
    if x.nil? || x == false
      flash[:notice] = "You must login as admin."
      redirect_to :controller => 'authenticate', :action => 'index'
    end
  end
end
