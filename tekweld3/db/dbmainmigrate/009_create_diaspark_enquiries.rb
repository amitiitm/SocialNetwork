class CreateDiasparkEnquiries < ActiveRecord::Migration
  def self.up
    create_table  :diaspark_enquiries  do |t|
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.string    :first_name, :limit => 80 ,:null=>false
      t.string    :last_name, :limit => 80 ,:null=>false
      t.string    :email, :limit => 50 ,:null=>false
      t.string    :company_name, :limit => 50 ,:null=>false
      t.string    :city, :limit => 25 
      t.string    :state, :limit => 25 
      t.string    :zip, :limit => 15
      t.string    :country, :limit => 20 
      t.string    :comments, :limit => 500
      t.string    :complete_flag, :limit => 1       
      
    end
  end

  def self.down
    drop_table :diaspark_enquiries
  end
end



	