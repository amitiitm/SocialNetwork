class CreateDiamondPacketUpdateLines < ActiveRecord::Migration
  def self.up
  create_table :diamond_packet_update_lines do |t|
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
      t.integer   :diamond_packet_update_id, :null=>false
      t.integer   :diamond_lot_id, :vendor_id
      t.string    :packet_no, :limit=>25
      t.decimal   :weight, :precision=>10, :scale=>4
      t.string    :location, :limit=>25
      t.string    :shape, :color, :clarity, :barcode_no, :limit=>18	
      t.string    :fluorescence, :polish, :symmetry, :proportion, :cut_grade, :limit=>15	
      t.string    :fluorescence_color, :limit=>10	
      t.decimal   :depth_per, :table_per, :size, :precision=>6, :scale=>2
      t.string    :max_girdle, :min_girdle, :girdle, :culet, :cert_type, :limit=>15	
      t.string    :certified_yn, :received_yn, :web_upload1, :web_upload2, :web_upload3, :limit=>1	
      t.string    :certificate_no, :laboratory, :limit=>20	
      t.string    :client_no, :limit=>25	
      t.decimal   :rapaport_price, :cost, :web_discount1, :web_price1, :precision=>10, :scale=>2
      t.decimal   :discount_per, :precision=>6, :scale=>2
      t.decimal   :web_discount2, :web_price2, :web_discount3, :web_price3, :precision=>10, :scale=>2
      t.string    :unit, :white_light, :color_light, :scintillation, :limit=>4	
      t.decimal   :length, :width, :depth, :precision=>5, :scale=>2
    end
  end

  def self.down
    drop_table :diamond_packet_update_lines
  end
end
