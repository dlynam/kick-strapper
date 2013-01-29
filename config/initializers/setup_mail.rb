ActionMailer::Base.smtp_settings = {
  :address              => "smtp.sendgrid.net",
  :port                 => 587,
  :domain               => "wheresthestyle.com",
  :user_name => "TenJack",
  :password => "sendgridemail",
  :authentication       => "plain",
  :enable_starttls_auto => true
}

#ActionMailer::Base.default_url_options[:host] = "pethero.org"

require 'development_mail_interceptor'
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?