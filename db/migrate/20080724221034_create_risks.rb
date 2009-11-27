class CreateRisks < ActiveRecord::Migration
  def self.up
    create_table :risks do |t|
      t.text :description
      t.string :name
      t.integer :status, :default => 2
      t.references :goal
      
      t.timestamps
    end
  end

  def self.down
    drop_table :risks
  end
end
