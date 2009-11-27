class CreateStakes < ActiveRecord::Migration
  def self.up
    create_table :stakes do |t|
      t.string :name
      t.boolean :enforced, :default => false
      
      t.references :user
      t.references :map
      t.references :goal

      t.timestamps
    end
  end

  def self.down
    drop_table :stakes
  end
end
