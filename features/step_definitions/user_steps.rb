module UserHelpers
  def current_user(admin = false)
    @current_user ||= User.create!(:email => current_email_address) do |user|
      user.name = 'Cucumber'
      user.admin = admin
      user.subdomain = current_subdomain
      'cucumber'.tap do |password|
        user.password = password
        user.password_confirmation = password
      end
      user.skip_confirmation!
    end
  end
end

World(UserHelpers)

When /^I log out$/ do
  Given %(I am on the home page)
  When %(I follow "#{ current_user.name } (Logout)")
  Then %(I should see "Login")
end

When /^I log in(?: with the password "(.*?)")?$/ do |password|
  password = password ? password : current_user.password
  Given %(I am on the home page)
  When %(I follow "Login")
  When %(I fill in "user_email" with "#{ current_user.email }")
  When %(I fill in "user_password" with "#{ password }")
  When %(I press "Login")
  Then %(I am on the home page)
  Then %(I should see "#{current_user.name} (Logout)")
end

Given /^I have signed up with the name "(.*?)" and the password "(.*?)"$/ do |name, password|
  @current_user ||= User.create!(:email => current_email_address) do |user|
    user.name = name
    user.subdomain = current_subdomain
    user.password = password
    user.password_confirmation = password
  end
end

Given /^I am logged in( as an admin)?$/ do |admin|
  admin = !admin.empty?
  assert_not_nil current_user(admin)
  assert_equal admin, current_user.admin
  When %(I log in)
end