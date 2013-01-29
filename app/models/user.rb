class User < ActiveRecord::Base

  attr_accessible :username, :email, :password, :password_confirmation
  attr_accessor :password, :password_confirmation, :current_password, :remember_me

  validates_presence_of :username, :email
  validates_presence_of :password, :if => :password_required?
  validates_presence_of :password_confirmation, :if => :password_required?

  validates_confirmation_of :password, :if => :password_required?

  validates_uniqueness_of :username, :case_sensitive => false
  validates_uniqueness_of :fb_user_id, :if => :fb_user_id_entered?
  validates_uniqueness_of :email, :case_sensitive => false, :if => :email_entered?

  validates_length_of :username, :within => 5..20
  validates_length_of :email, :within => 5..70, :if => :email_entered?
  validates_length_of :password, :within => 5..20, :if => :password_required?

  validates_format_of :username,
                      :with => /^\w+$/i,
                      :message => "must contain only letters and numbers"
  validates_format_of :email,
                      :with => /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i,
                      :message => "is not valid", :if => :email_entered?
  validates_format_of :password,
                      :with => /^[A-Z0-9_]*$/i,
                      :message => "must contain only letters, numbers, and underscores"
                    
  before_validation do
    self.hashed_password = User.encrypt(password) if !self.password.blank?
  end

  def self.encrypt(string)
    return Digest::SHA256.hexdigest(string)
  end

  def remember!(cookies)
    cookie_expiration = 3.weeks.from_now
    cookies[:remember_me] = { :value => "1", :expires => cookie_expiration }
    self.authorization_token = Digest::SHA1.hexdigest("#{username}")
    save!
    cookies[:authorization_token] = {
      :value => authorization_token,
      :expires => cookie_expiration }
  end

  def forget!(cookies)
    cookies.delete(:remember_me)
    cookies.delete(:authorization_token)
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def generate_token(column)
    self[column] = SecureRandom.urlsafe_base64  #while User.exists?(conditions: {column => self[column]}) this is mongoid!!
  end

  def self.authenticate(email_or_username, password)
    email_or_username =~ /@/ ?
      find_by_email_and_hashed_password_and_enabled(email_or_username, User.encrypt(password), true) :
      find_by_username_and_hashed_password_and_enabled(email_or_username, User.encrypt(password), true)
  end

  def correct_password?(params)
    User.encrypt(params[:current_password]) == hashed_password
  end

  def password_errors(params)
    self.password = params[:password]
    self.password_confirmation = params[:password_confirmation]
    valid?
    errors.add(:current_password, "is incorrect.")
  end

  def to_param  # overridden for username routes
    username
  end

  private

  def email_entered?
    !self.email.blank?
  end

  def fb_user_id_entered?
    !self.fb_user_id.nil?
  end

  def password_required?
    self.fb_user_id ? false : self.hashed_password.blank? || !self.password.blank?
  end
  
end
