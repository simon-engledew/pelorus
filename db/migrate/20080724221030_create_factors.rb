class CreateFactors < ActiveRecord::Migration
  def self.up
    create_table :factors do |t|
      t.text :description
      t.string :name
      
      t.string :target
      t.string :report
      t.string :fail
      
      t.string :likely
      t.string :best
      t.string :worst
      
      t.references :goal
      
      t.timestamps
    end
  end

  def self.down
    drop_table :factors
  end
end
