Warden::Manager.after_set_user do |user, auth, options|
  unless user.subdomain == SubdomainFu.current_subdomain(auth.request)
    auth.logout
    throw(:warden, :message => 'Not permitted access to this subdomain')
  end
end