class CreateCatalogOrders < ActiveRecord::Migration
  def self.up
    create_table :catalog_orders do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.integer   :user_id, :default=>0       
      t.integer   :customer_id, :default=>0             
      t.string    :order_no,  :limit=>50 , :default=>' '
      t.datetime  :order_date
      t.string    :status,  :limit=>1 , :default=>'N'
      t.string    :name,  :limit=>50 , :default=>' '
      t.string    :bill_address1,  :limit=>40 , :default=>' '
      t.string    :bill_address2,  :limit=>40 , :default=>' '
      t.string    :bill_city,  :limit=>20 , :default=>' '
      t.string    :bill_state,  :limit=>5 , :default=>' '
      t.string    :bill_zip,  :limit=>15 , :default=>' '
      t.string    :bill_country,  :limit=>20 , :default=>' '
      t.string    :ship_address1,  :limit=>40 , :default=>' '
      t.string    :ship_address2,  :limit=>40 , :default=>' '
      t.string    :ship_city,  :limit=>20 , :default=>' '
      t.string    :ship_state,  :limit=>5 , :default=>' '
      t.string    :ship_zip,  :limit=>15 , :default=>' '
      t.string    :ship_country,  :limit=>20 , :default=>' '
      t.string    :phone1,  :limit=>15 , :default=>' '
      t.string    :phone2,  :limit=>15 , :default=>' '
      t.string    :fax1,  :limit=>15 , :default=>' '
      t.string    :cell_no,  :limit=>15 , :default=>' '
      t.string    :email,  :limit=>25 , :default=>' '
      t.string    :comments,  :limit=>200 , :default=>' '
      t.datetime  :planned_ship_date
      t.datetime  :actual_ship_date
      t.datetime  :cancel_date
      
    end
  end

  def self.down
    drop_table :catalog_orders
  end
end
