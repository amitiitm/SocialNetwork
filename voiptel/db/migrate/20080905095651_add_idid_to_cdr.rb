class AddIdidToCdr < ActiveRecord::Migration
  def self.up
    add_column :cdrs, :idid, :integer
  end

  def self.down
    remove_column :cdrs, :idid
  end
end
