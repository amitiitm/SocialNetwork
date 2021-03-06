class CreateCatalogItemPacketUpdateLines < ActiveRecord::Migration
  def self.up
  create_table :catalog_item_packet_update_lines do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.string    :trans_bk, :limit=>4, :null=>false
      t.string    :trans_no, :limit=>18, :null=>false
      t.datetime  :trans_date, :null=>false	
      t.string    :serial_no, :limit=>6
      t.integer   :catalog_item_id, :null=>false
      t.integer   :catalog_item_packet_update_id, :null=>false
      t.string    :code,  :limit=>25, :null=>false
      t.string    :description,  :limit=>100, :null=>false
      t.string    :attribute1, :limit=>50
      t.string    :attribute2, :limit=>50
      t.string    :attribute3, :limit=>50
      t.string    :attribute4, :limit=>50
      t.string    :attribute5, :limit=>50
      t.string    :attribute6, :limit=>50
      t.string    :attribute7, :limit=>50
      t.string    :attribute8, :limit=>50
      t.string    :attribute9, :limit=>50
      t.string    :attribute10, :limit=>50
    end
  end

  def self.down
    drop_table :catalog_item_packet_update_lines
  end
end
