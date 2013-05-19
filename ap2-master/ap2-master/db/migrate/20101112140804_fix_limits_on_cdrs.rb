class FixLimitsOnCdrs < ActiveRecord::Migration
  def self.up
    change_column :cdrs, :dst_number, :string, :limit => 20
    change_column :cdrs, :rate, :decimal, :precision => 5, :scale => 4
    change_column :cdrs, :cost, :decimal, :precision => 7, :scale => 4
    change_column :cdrs, :user_input, :string, :limit => 20
  end

  def self.down
    change_column :cdrs, :user_input, :string
    change_column :cdrs, :cost, :string
    change_column :cdrs, :rate, :string
    change_column :cdrs, :dst_number, :string
  end
end
