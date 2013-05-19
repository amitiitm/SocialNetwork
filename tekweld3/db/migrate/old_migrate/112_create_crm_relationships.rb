class CreateCrmRelationships < ActiveRecord::Migration
  def self.up
    create_table :crm_relationships do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0 
      t.integer   :party1_id, :party2_id
      t.string    :description , :linit=>50
    end
  end

  def self.down
    drop_table :crm_relationships
  end
end
