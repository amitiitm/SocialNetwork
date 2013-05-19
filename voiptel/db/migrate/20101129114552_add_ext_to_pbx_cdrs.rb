class AddExtToPbxCdrs < ActiveRecord::Migration
  def self.up
    add_column :pbx_cdrs, :ext, :string, :limit => 20
  end

  def self.down
    remove_column :pbx_cdrs, :ext
  end
end
