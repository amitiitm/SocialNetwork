class CreateCatalogItemLines < ActiveRecord::Migration
  def self.up
    create_table :catalog_item_lines do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.integer   :catalog_item_id, :limit=>1, :null=>false
      t.string    :serial_no, :limit=>6
      t.integer   :assemble_item_id, :null=>false
      t.decimal   :qty, :precision=>10, :scale=>2
      t.decimal   :cost, :precision=>12, :scale=>2
    end
  end

  def self.down
    drop_table :catalog_item_lines
  end
end
