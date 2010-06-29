class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.text :message
      t.references :user
      t.references :parent
      t.string :parent_type
      t.integer :status, :default => nil
      t.boolean :override_status, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
