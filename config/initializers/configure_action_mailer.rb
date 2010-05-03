ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => 'smtp.gmail.com',
  :port => 587,
  :domain => 'googlemail.com',
  :user_name => 'toolforchange@googlemail.com',
  :password => '7be017ffe4c8d6f5c95a1f90',
  :authentication => :login
}