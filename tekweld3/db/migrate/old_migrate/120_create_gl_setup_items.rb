class CreateGlSetupItems < ActiveRecord::Migration
  def self.up
    create_table :gl_setup_items do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.integer   :gl_setup_id, :null=>false
      t.string    :item_type, :null=>false, :limit=>1
      t.integer   :sales_account_id, :null=>false
      t.integer   :purchase_account_id, :null=>false
    end
  end

  def self.down
    drop_table :gl_setup_items
  end
end
