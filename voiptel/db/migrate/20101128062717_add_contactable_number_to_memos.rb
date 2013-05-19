class AddContactableNumberToMemos < ActiveRecord::Migration
  def self.up
    add_column :memos, :contactable_number_type, :string, :limit => 10
    add_column :memos, :contactable_number_id, :integer
  end

  def self.down
    remove_column :memos, :contactable_number_id
    remove_column :memos, :contactable_number_type
  end
end
