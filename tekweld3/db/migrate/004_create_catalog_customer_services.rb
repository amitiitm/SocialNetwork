class CreateCatalogCustomerServices < ActiveRecord::Migration
  def self.up
    create_table :catalog_customer_services do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.string    :section,      :limit => 100
      t.string    :main_heading_code,      :limit => 25
      t.string    :main_heading,      :limit => 100
      t.integer   :sequence
      t.string    :diaspark_default, :limit=>1, :default=>'Y'
      t.string    :visible_flag, :limit=>1, :default=>'Y'
    end
  end

  def self.down
    drop_table :catalog_customer_services
  end
end
