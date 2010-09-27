Warden::Manager.after_set_user do |user, auth, options|
  unless [SubdomainFu.current_subdomain(auth.request) || '', '*'].include?(user.subdomain)
    auth.logout
    throw(:warden, :message => 'Not permitted access to this subdomain')
  end
end