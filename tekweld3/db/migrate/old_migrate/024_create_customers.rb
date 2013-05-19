class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
        t.column :company_id, :int, :null=>false
        t.column :created_by, :int , :default=>0
        t.column :created_at, :datetime
        t.column :updated_by, :int, :default=>0
        t.column :updated_at, :datetime
        t.column :trans_flag, :string,:limit=>1 ,:default=>'A'
        t.column :update_flag, :string,:limit=>1 ,:default=>'A'
        t.column :lock_version, :int, :default=>0
        t.column :code, :string,:limit=>25, :null=>false
        t.column :name, :string,:limit=>50 , :default=>' '
        t.column :address1, :string,:limit=>50 , :default=>' '
        t.column :address2, :string,:limit=>50 , :default=>' '
        t.column :city, :string,:limit=>25 , :default=>' '
        t.column :state, :string,:limit=>25 , :default=>' '
        t.column :zip, :string,:limit=>15 , :default=>' '
        t.column :country, :string,:limit=>20 , :default=>' '
        t.column :phone1, :string,:limit=>50 , :default=>' '
        t.column :phone2, :string,:limit=>50 , :default=>' '
        t.column :fax1, :string,:limit=>50 , :default=>' '
        t.column :cell_no, :string,:limit=>15 , :default=>' '
        t.column :email, :string,:limit=>200 , :default=>' '
        t.column :customer_category_id, :int, :default=>0       
        t.column :tax_id, :int, :default=>0
        t.column :discount_per, :decimal,:precision=>5, :scale=>2 , :default=>0
        t.column :discount_days, :decimal,:precision=>5, :scale=>0 
        t.column :due_days, :decimal,:precision=>5, :scale=>0 
        t.column :inv_type, :string,:limit=>4 
        t.column :notes_text, :text 
        t.column :territory, :string,:limit=>10 , :default=>' '
        t.column :territory2, :string,:limit=>10 , :default=>' '
        t.column :territory3, :string,:limit=>10 , :default=>' '
        t.column :credit_limit, :decimal,:precision=>12, :scale=>2 
        t.column :price_level, :string,:limit=>1 ,:default=>'A'
        t.column :salesperson_code, :string, :limit=>8
        t.column :message_id, :string,:limit=>8 , :default=>' '
        t.column :inv_print_no, :string,:limit=>8 , :default=>' '
        t.column :shipping_code, :string, :limit=>25
        t.column :website, :string,:limit=>150 , :default=>' '
        t.column :email_yn, :string,:limit=>1 ,:default=>'N'
        t.column :fax_yn, :string,:limit=>1 ,:default=>'N'
        t.column :print_yn, :string,:limit=>1 ,:default=>'N'
        t.column :message_yn, :string,:limit=>1 ,:default=>'N'
        t.column :paymentpriority, :string,:limit=>1 ,:default=>'A'
        t.column :ten99_yn, :string,:limit=>1 ,:default=>'N'
        t.column :ein_no, :string,:limit=>20 , :default=>' '
        t.column :valid_dt, :datetime 
        t.column :udf1, :string,:limit=>100 , :default=>' '
        t.column :udf2, :string,:limit=>100 , :default=>' '
        t.column :udf3, :string,:limit=>100 , :default=>' '
        t.column :udf4, :string,:limit=>100 , :default=>' '
        t.column :udf5, :string,:limit=>100 , :default=>' '
        t.column :udf6, :string,:limit=>100 , :default=>' '
        t.column :dunning_yn, :string,:limit=>1 ,:default=>'N'
        t.column :salescomm_per, :decimal,:precision=>5, :scale=>2 , :default=>0
        t.column :coop_per, :decimal,:precision=>5, :scale=>2 , :default=>0
        t.column :billto_id, :int
        t.column :base_goldprice, :decimal,:precision=>12, :scale=>5 , :default=>0
        t.column :memo_term_code, :string,:limit=>25 , :default=>' '
        t.column :invoice_term_code, :string,:limit=>25 , :default=>' '
        t.column :stop_ship, :string,:limit=>1, :null=>false,:default=>'N'
        t.column :jbt_ranking, :string,:limit=>10 , :default=>' '
        t.column :credit_approval_flag, :string,:limit=>1 ,:default=>'Y'
        t.column :blacklisted_flag, :string,:limit=>1 , :default=>' '
        t.column :bank_account_no, :string,:limit=>30 , :default=>' '
        t.column :wfca_flag, :string,:limit=>1 ,:default=>'N'
        t.column :passport_no, :string,:limit=>30 , :default=>' '
        t.column :guarantee_name, :string,:limit=>50 , :default=>' '
        t.column :contact1, :string,:limit=>50 , :default=>' '
        t.column :contact2, :string,:limit=>50 , :default=>' '
        t.column :contact3, :string,:limit=>50 , :default=>' '
        t.column :contact4, :string,:limit=>50 , :default=>' '
        t.column :contact1_phone, :string,:limit=>15 , :default=>' '
        t.column :contact2_phone, :string,:limit=>15 , :default=>' '
        t.column :inactive, :string,:limit=>1 ,:default=>'N'
        t.column :bank_name, :string,:limit=>50 , :default=>' '
        t.column :bank_address1, :string,:limit=>50 , :default=>' '
        t.column :bank_address2, :string,:limit=>50 , :default=>' '
        t.column :bank_phone, :string,:limit=>50 , :default=>' '
        t.column :bank_fax, :string,:limit=>50 , :default=>' '
        t.column :bank_contact_person, :string,:limit=>50 , :default=>' '
        t.column :so_partial_ship_flag, :string,:limit=>1 , :default=>' '
        t.column :so_item_partial_ship_flag, :string,:limit=>1 ,:default=>'N'
        t.column :collection, :string,:limit=>1 ,:default=>'N'
        t.column :impairment_percent, :decimal,:precision=>6, :scale=>2 , :default=>0
        t.column :style_suffix, :string,:limit=>2 ,:default=>'AA'
        t.column :location_code, :string,:limit=>25 ,:default=>'NA'
        t.column :type1, :string,:limit=>4
        t.column :type2, :string,:limit=>4
        t.column :postdated_checks, :decimal,:precision=>4, :scale=>0 
        t.column :return_checks, :decimal,:precision=>4, :scale=>0 
        t.column :gl_account1_id,:int
        t.column :gl_account2_id, :int
        t.column :gl_account3_id, :int
        t.column :gl_account4_id, :int
        t.column :default_ship_code, :string, :limit=>25
    end
  end

  def self.down
    drop_table :customers
  end
end
