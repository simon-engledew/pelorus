class AddMapToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :map_id, :integer, :references => :maps
    add_index :events, :map_id
    ActiveRecord::Base.record_timestamps = false
    Event.all.each do |event|
        event.update_attribute(:map, event.model.map)
    end
    ActiveRecord::Base.record_timestamps = true
  end

  def self.down
    remove_column :events, :map_id
    remove_index :events, :map_id
  end
end
