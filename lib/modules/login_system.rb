module LoginSystem
  protected
  
  def is_logged_in?
    @logged_in_user ||= User.find(session[:user]) if session[:user] 
    #if session[:user]
    #  @logged_in_user ||= User.find(session[:user])
    #else
=begin
      @koala = Koala::Facebook::OAuth.new
      @facebook_cookies = @koala.get_user_info_from_cookie(cookies)
      if @facebook_cookies
        @logged_in_user ||= User.find_by_fb_user_id(@koala.get_user_from_cookies(cookies))
      end
=end
    #end
  end
  
  def logged_in_user
    return @logged_in_user if is_logged_in?
  end
  
  def logged_in_user=(user)
    if !user.nil?
      session[:user] = user.id
      @logged_in_user = user
    end
  end
  
  def self.included(base)
    base.send :helper_method, :is_logged_in?, :logged_in_user
  end
  
  def login_required
    unless is_logged_in?
      flash[:notice] = "Please log in first."
      redirect_to :controller => 'account', :action => 'login'
    end
  end

end