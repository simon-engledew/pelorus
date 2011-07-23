class AddSubdomainToTopLevelModels < ActiveRecord::Migration
  def self.up
    add_column :maps, :subdomain, :string
    add_column :users, :subdomain, :string
    add_index :maps, :subdomain
    add_index :users, :subdomain
  end

  def self.down
    remove_column :maps, :subdomain
    remove_column :users, :subdomain
  end
end
