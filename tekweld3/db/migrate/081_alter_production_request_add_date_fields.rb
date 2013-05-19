class AlterProductionRequestAddDateFields < ActiveRecord::Migration
  def self.up
    add_column :production_requests, :ship_date, :datetime
    add_column :production_requests, :due_date, :datetime
    add_column :production_requests, :cancel_date, :datetime
  end

  def self.down
    remove_column :production_requests, :ship_date
    remove_column :production_requests, :due_date
    remove_column :production_requests, :cancel_date
  end
end
