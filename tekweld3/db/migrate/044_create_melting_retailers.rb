class CreateMeltingRetailers < ActiveRecord::Migration
  def self.up
    create_table :melting_retailers do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version, :default => 0
      t.string    :code,  :limit=>25 
      t.string    :first_name,  :limit=>50
      t.string    :last_name,  :limit=>50
      t.string    :name,  :limit=>100
      t.string    :description,  :limit=>100
      t.string    :password,  :limit=>20
      t.string    :logo_file_name,  :limit=>30
    end
  end

  def self.down
    drop_table :melting_retailers
  end
end
