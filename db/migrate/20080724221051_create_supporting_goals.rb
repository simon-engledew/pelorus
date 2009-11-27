class CreateSupportingGoals < ActiveRecord::Migration
  def self.up
    create_table :supporting_goals do |t|
      t.references :goal
      t.references :supported_by
      t.timestamps
    end
  end

  def self.down
    drop_table :supporting_goals
  end
end
