class UsersController < ApplicationController
  layout "site"

  before_filter :already_logged_in?, :only => [:new, :create, :fb_create, :fb_new]
  before_filter :login_required, :only => [:edit, :update]
  before_filter :parse_facebook_cookies, :only => [:fb_create, :fb_new]

  def new
    @register = true
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.referer = session[:referer]
    if @user.save
      self.logged_in_user = @user
      session[:referer] = nil
      flash[:notice] = "Your account has been created.  Welcome!"
      redirect_to root_path
    else
      render :action => 'new'
    end
  end

  def fb_new
    raise @fb_cookies.inspect
    @user = User.new
    fb_graph ||= Koala::Facebook::API.new(@fb_cookies['access_token'])
    @user.email = fb_graph.get_object("me")['email']
  end

  def fb_create
    fb_graph ||= Koala::Facebook::API.new(@fb_cookies['access_token'])
    email = fb_graph.get_object("me")['email']
    existing_user = User.find_by_email(email)
    if existing_user
      existing_user.fb_user_id = @fb_cookies['user_id']
      existing_user.verified_email = true
      existing_user.save
      self.logged_in_user = existing_user
      flash[:notice] = "Welcome back!"
      redirect_to root_path
    else
      @user = User.new({:email => email})
      @user.fb_user_id = @fb_cookies['user_id']
      @user.verified_email = true
      if @user.save
        self.logged_in_user = @user
        UserMailer.registration_confirmation(@user).deliver unless Rails.env.development?
        redirect_to root_path
      else
        flash[:notice] = "There was a problem connecting your facebook account."
        redirect_to new_user_path
      end
    end
  end

  def edit
    @user = logged_in_user
  end

  def update
    @user = logged_in_user
    @nav = "settings"
    attribute = params[:user].delete("attribute")
    case attribute
    when "email"
      try_to_update @user, attribute
    when "password"
      if @user.correct_password?(params[:user])
        try_to_update @user, attribute
      else
        @user.password_errors(params[:user])
        render :action => 'edit'
      end
    end
  end

  def show
    @user = User.find_by_username(params[:id])
  end

  protected

  def try_to_update(user, attribute)
    if user.update_attributes!(params[:user])
      flash[:notice] = "Your #{attribute} has been updated."
      redirect_to root_path
    else
      flash[:notice] = "There was a problem updating."
      render :action => 'edit'
    end
  end
  
end
