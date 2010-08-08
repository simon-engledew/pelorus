ActiveSupport::SecureRandom.hex(10).tap do |password|
  (@user = User.new(:name => 'Admin', :admin => true, :email => 'admin@toolforchange.com', :password => password, :password_confirmation => password) do |user|
    user.skip_confirmation!
    user.admin = true
  end).save!
  
  $stdout.puts "db:seed admin {:password => #{@user.password}, :id => #{@user.id}}"
end
