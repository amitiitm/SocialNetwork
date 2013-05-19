class CreateTypes < ActiveRecord::Migration
  def self.up
    create_table :types do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.string    :type_cd,  :limit=>20, :null=>false
      t.string    :subtype_cd,  :limit=>20, :null=>false
      t.string    :value,  :limit=>50, :null=>false
      t.string    :description,  :limit=>100
    end
  end

  def self.down
    drop_table :types
  end
end
