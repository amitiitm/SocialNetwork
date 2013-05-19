class AddEmailFieldsToNotes < ActiveRecord::Migration
  def self.up
    add_column :notes, :email_from, :string, :limit=>50
    add_column :notes, :email_to, :string, :limit=>500
    add_column :notes, :email_cc, :string, :limit=>500
    add_column :notes, :email_bcc, :string, :limit=>500
  end

  def self.down
    remove_column :notes, :email_from
    remove_column :notes, :email_to
    remove_column :notes, :email_cc
    remove_column :notes, :email_bcc
  end
end
