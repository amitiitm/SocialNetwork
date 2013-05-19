class AlterCustomerAddEmails < ActiveRecord::Migration
  def self.up
    add_column :customers, :alternate_email_id, :string ,:limit=>100
  end

  def self.down
    remove_column :customers, :alternate_email_id
  end
end
