class CreateGoals < ActiveRecord::Migration
  def self.up
    create_table :goals do |t|
      t.text :description
      t.string :name
      t.boolean :propagate, :default => true
      t.references :parent
      t.references :map
      t.timestamps
    end
  end

  def self.down
    drop_table :goals
  end
end
