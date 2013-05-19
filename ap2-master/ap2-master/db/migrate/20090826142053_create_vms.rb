class CreateVms < ActiveRecord::Migration
  def self.up
    create_table :vms do |t|
      t.string :callerid
      t.integer :duration
      t.integer :vm_box_id
      t.string :file_name

      t.timestamps
    end
  end

  def self.down
    drop_table :vms
  end
end
