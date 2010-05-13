class AddContextToFactors < ActiveRecord::Migration
  def self.up
    add_column :factors, :priority, :string, :default => 'medium'
    add_column :factors, :benchmark, :string
    add_column :factors, :benchmark_source, :string
  end

  def self.down
    remove_column :factors, :benchmark_source
    remove_column :factors, :benchmark
    remove_column :factors, :priority
  end
end
