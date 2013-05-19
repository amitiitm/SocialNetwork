class CreateCatalogItemPacketUpdates < ActiveRecord::Migration
  def self.up
  create_table :catalog_item_packet_updates do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.string    :trans_bk, :ref_trans_bk, :limit=>4, :null=>false
      t.string    :trans_no, :ref_trans_no, :limit=>18, :null=>false
      t.datetime  :trans_date, :null=>false	
      t.string    :account_period_code, :limit=>8, :null=>false
      t.string    :file_name,  :limit=>100
      t.string    :remarks,  :limit=>200
    end
  end

  def self.down
    drop_table :catalog_item_packet_updates
  end
end
