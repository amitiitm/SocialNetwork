class CreatePacketLabelMappings < ActiveRecord::Migration
  def self.up
    create_table  :packet_label_mappings do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.string    :generic_attribute_label, :limit=>50 
      t.string    :specific_attribute_label, :limit=>50      
    end
  end

  def self.down
    drop_table :packet_label_mappings
  end
end
