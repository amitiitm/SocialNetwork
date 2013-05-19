class AddCodecToCarriers < ActiveRecord::Migration
  def self.up
    add_column :carriers, :codec, :string, :limit => 80
  end

  def self.down
    remove_column :carriers, :codec
  end
end
