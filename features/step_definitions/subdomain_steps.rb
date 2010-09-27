module SubdomainHelpers
  
  def current_subdomain
    # SubdomainFu.subdomain_from(open_session.host) || ''
    SubdomainFu.tld_size = 0
    'www.example'
  end
  
end
World(SubdomainHelpers)

# Before do
#   host! 'cucumber.toolforchange.com'
# end