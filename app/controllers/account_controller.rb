class AccountController < ApplicationController
  layout "site"

  before_filter :already_logged_in?, :only => [:login, :authenticate]
  before_filter :parse_facebook_cookies, :only => [:fb_authenticate]

  def login
  end

  def authenticate
    self.logged_in_user = User.authenticate(params[:user][:email], params[:user][:password])
    if is_logged_in?
      params[:user][:remember_me] ? logged_in_user.remember!(cookies) : logged_in_user.forget!(cookies)
      flash[:notice] = "Welcome back! We've missed you."
      redirect_to root_path
    else
      flash[:error] = "I'm sorry; either your username or password was incorrect."
      redirect_to :action => 'login'
    end
  end
  
  def fb_authenticate
    if @fb_cookies
      user = User.find_by_fb_user_id(@fb_cookies['user_id'])
      if user
        self.logged_in_user = user
        logged_in_user.remember!(cookies)
        flash[:notice] = "Welcome back!"
        redirect_to root_path
      else
        flash[:notice] = "Please create a username."
        redirect_to fb_new_users_path
      end
    else
      redirect_to root_path
    end
  end

  def logout
   # if request.post?
      reset_session
      cookies.delete(:authorization_token)
      flash[:notice] = "You have been logged out."
   # end
    redirect_to login_path
  end

end
