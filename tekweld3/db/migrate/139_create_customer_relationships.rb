class CreateCustomerRelationships < ActiveRecord::Migration
  def self.up
    create_table  :customer_relationships do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.integer   :customer_id
      t.string    :relationship, :limit=>50
      t.string    :related_customer_code, :limit=>25
      t.string    :first_name , :limit =>50
      t.string    :last_name , :limit =>50
      t.string    :phone, :limit=>50
      t.string    :email , :limit=>100
      t.string    :birth_date, :limit=>6
      t.string    :anniversary_date, :limit=>6
    end
  end

  def self.down
    drop_table :customer_relationships
  end
end
