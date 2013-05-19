class CreateEnquiries < ActiveRecord::Migration
  def self.up
    create_table :enquiries do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.string    :fname,  :limit=>50 , :default=>' '
      t.string    :lname,  :limit=>50 , :default=>' '
      t.string    :address1,  :limit=>40 , :default=>' '
      t.string    :address2,  :limit=>40 , :default=>' '
      t.string    :city,  :limit=>20 , :default=>' '
      t.string    :state,  :limit=>5 , :default=>' '
      t.string    :zip,  :limit=>15 , :default=>' '
      t.string    :country,  :limit=>20 , :default=>' '
      t.string    :phone,  :limit=>15 , :default=>' '
      t.string    :email,  :limit=>100 , :default=>' '
      t.string    :subject,  :limit=>50 , :default=>' '
      t.string    :comments,  :limit=>1000 , :default=>' '
      t.string    :status,  :limit=>1000 , :default=>'N'
      t.string    :complete_flag, :limit=>10
      t.string    :item_description, :limit=>100
    end
  end

  def self.down
    drop_table :enquiries
  end
end
