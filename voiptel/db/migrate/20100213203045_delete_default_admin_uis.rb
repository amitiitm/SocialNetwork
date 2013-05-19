class DeleteDefaultAdminUis < ActiveRecord::Migration
  def self.up
    drop_table :default_admin_uis
  end

  def self.down
    create_table "default_admin_uis", :force => true do |t|
      t.string   "partial_name"
      t.string   "partial_location"
      t.string   "container"
      t.integer  "position"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "owner"
      t.integer  "admin_user_id"
    end
    
  end
end
