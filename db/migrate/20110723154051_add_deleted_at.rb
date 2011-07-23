class AddDeletedAt < ActiveRecord::Migration
  tables = [:maps, :goals, :factors, :risks, :supporting_goals, :stakes, :comments, :users]
  
  def self.up
    tables.each do |table|
      add_column table, :deleted_at, :datetime
    end
  end

  def self.down
    tables.each do |table|
      remove_column table, :deleted_at
    end
  end
end
