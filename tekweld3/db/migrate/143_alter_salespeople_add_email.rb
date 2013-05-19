class AlterSalespeopleAddEmail < ActiveRecord::Migration
  def self.up
    add_column :salespeople, :email, :string ,:limit=>200
  end

  def self.down
    remove_column :salespeople, :email
  end
end
