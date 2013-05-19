class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.integer :contact_type
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
