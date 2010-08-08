Given /^I have signed up with the name "(.*?)" and the password "(.*?)"$/ do |name, password|
  User.new(:email => current_email_address) do |user|
    user.name = name
    user.password = password
    user.password_confirmation = password
  end.save!
end

Given /^I am logged in( as an admin)?$/ do |admin|
  (@user = User.new(:email => current_email_address) do |user|
    user.name = 'Cucumber'
    'cucumber'.tap do |password|
      user.admin = !admin.empty?
      user.password = password
      user.password_confirmation = password
      user.skip_confirmation!
    end
  end).save!
  Given %(I am on the home page)
  When %(I follow "Login")
  When %(I fill in "user_email" with "#{ @user.email }")
  When %(I fill in "user_password" with "#{ @user.password }")
  When %(I press "Login")
  Then %(I am on the home page)
  And %(I should see "Cucumber (Logout)")
end