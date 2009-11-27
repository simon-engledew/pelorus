class CreateMaps < ActiveRecord::Migration
  def self.up
    create_table :maps do |t|
      t.text :description
      t.string :name
      t.integer :manager_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :maps
  end
end
