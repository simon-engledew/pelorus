class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :action
      
      t.references :user
      t.string :subdomain
      
      t.references :model
      t.string :model_type
      
      t.timestamps
    end
    add_index :events, :subdomain
  end

  def self.down
    drop_table :stakes
  end
end
