class CreateDiamondLots < ActiveRecord::Migration
  def self.up
    create_table :diamond_lots do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.string    :lot_number, :limit=>25	
      t.string    :description, :limit=>50
      t.string    :stone_type, :shape, :color, :clarity, :quality, :setting, :limit=>18	
      t.decimal   :ct_average, :ct_from, :ct_to, :precision=>10, :scale=>3
      t.decimal   :size, :size_from, :size_to, :sieve_plate_from, :sieve_plate_to, :precision=>7, :scale=>2
      t.string    :location, :limit=>25
      t.string    :cert_Flag, :limit=>1	
      t.string    :cost_unit, :limit=>4	
      t.decimal   :cost_per_pcs, :cost_per_ct, :price_per_pcs,	:price_per_ct, :precision=>10, :scale=>2
      t.integer   :diamond_category_id
    end
  end

  def self.down
    drop_table :diamond_lots
  end
end
