class AddInputTimeToCdrs < ActiveRecord::Migration
  def self.up
    add_column :cdrs, :input_time, :integer
  end

  def self.down
    remove_column :cdrs, :input_time
  end
end
