class CreateVmBoxes < ActiveRecord::Migration
  def self.up
    create_table :vm_boxes do |t|
      t.string :name
      t.string :uri
      t.integer :user_id
      t.integer :account_id

      t.timestamps
    end
  end

  def self.down
    drop_table :vm_boxes
  end
end
