class CreateAdminUis < ActiveRecord::Migration
  def self.up
    create_table :admin_uis do |t|
      t.integer :default_ui_id
      t.integer :admin_user_id
      t.integer :position
      t.string :container
      t.string :partial_name
      t.string :partial_location
      t.string :owner
      
      t.timestamps
    end
  end

  def self.down
    drop_table :admin_uis
  end
end
