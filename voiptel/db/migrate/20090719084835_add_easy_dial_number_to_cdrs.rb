class AddEasyDialNumberToCdrs < ActiveRecord::Migration
  def self.up
    add_column :cdrs, :easy_dial_number, :string, :limit => 10
  end

  def self.down
    remove_column :cdrs, :easy_dial_number
  end
end
