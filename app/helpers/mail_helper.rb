module MailHelper
  def current_subdomain
    Thread.current[:current_subdomain]
  end
end