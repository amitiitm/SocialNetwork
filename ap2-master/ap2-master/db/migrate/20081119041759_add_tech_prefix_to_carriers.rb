class AddTechPrefixToCarriers < ActiveRecord::Migration
  def self.up
    add_column :carriers, :tech_prefix, :string
  end

  def self.down
    remove_column :carriers, :tech_prefix
  end
end
