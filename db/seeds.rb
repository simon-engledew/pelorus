ActiveSupport::SecureRandom.hex(10).tap do |password|
  $stdout.puts "db:seed admin password: #{password}"
  
  User.new(:name => 'Admin', :admin => true, :email => 'admin@toolforchange.com', :password => password, :password_confirmation => password) do |user|
    user.skip_confirmation!
    user.admin = true
  end.save!
end
