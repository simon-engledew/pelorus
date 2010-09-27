Given /^I have a map named "(.*?)"$/ do |map_name|
  Map.create!(:name => map_name) do |map|
    map.manager = current_user
    map.subdomain = current_subdomain
  end
end

Then /^I should see the (Map|Goal|Risk|Factor) "(.*?)"$/ do |parent_type, name|
  Then %(I should see the title "<#{parent_type}> #{name}")
end

Then /^I should see the (\d+)(?:st|nd|rd|th)? breadcrumb "(.*?)"$/ do |index, breadcrumb|
  Then %(I should see "#{breadcrumb}" within "div#breadcrumbs > ul > li:nth-child(#{index})")
end

Then /^I should see the breadcrumbs "(.*?)"$/ do |breadcrumbs|
  breadcrumbs.split(/,\s?/).each_with_index do |breadcrumb, index|
    Then %(I should see the #{index + 1} breadcrumb "#{breadcrumb}")
  end
end

When /^I follow the breadcrumb "(.*?)"$/ do |breadcrumb|
  When %(I follow "#{breadcrumb}" within "div#breadcrumbs > ul")
end

Then /^I should see the title "(.*)?"$/ do |title|
  Then %(I should see "#{title}" within "div#content h1")
end

Given /^I have a goal named "(.*?)" in the (map|goal) "(.*?)"$/ do |goal_name, parent_type, parent_name|
  parent = parent_type.camelize.constantize.find_by_name!(parent_name)
  parent.map.goals.build(:name => goal_name) do |goal|
    goal.parent_id = parent.id if parent.is_a?(Goal)
  end.save!

end

Given /^I have fixtures$/ do
  YamlDb.load Rails.root.join('db', 'data.yml')
  # Fixtures.reset_cache
  # fixtures_folder = File.join(RAILS_ROOT, 'test', 'fixtures')
  # fixtures = Dir[File.join(fixtures_folder, '*.yml')].map {|f| File.basename(f, '.yml') }
  # Fixtures.create_fixtures(fixtures_folder, fixtures)
  # [Map, Goal].each do |model|
  #   model.all.each(&:create_default_stakes)
  # end
end

Given /^I am visiting "(.*?)"$/ do |host|
  SubdomainFu.tld_size = 1
  host! host
end