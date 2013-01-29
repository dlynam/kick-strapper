class PasswordResetsController < ApplicationController
  layout "site"

  before_filter :already_logged_in?
  before_filter :find_user, :only => [:edit, :update]

  def create
    user = User.find_by_email(params[:user][:email])
    user.send_password_reset if user
    redirect_to login_path, :notice => "An email has been sent with password reset instructions."
  end

  def update
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :message => "Password reset has expired."
    elsif @user.update_attributes(params[:user])
      redirect_to login_path, :notice => "You can now login with your new password."
    else
      render :edit
    end
  end

  private

  def find_user
    @user = User.find_by_password_reset_token(params[:id])
    unless @user
      flash[:notice] = "User not found."
      redirect_to login_path
    end
  end

end
