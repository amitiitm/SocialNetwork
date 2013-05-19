class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.string    :code, :limit=>25
      t.string    :name,  :limit=>50
      t.string    :description, :limit=>100
      t.integer   :document_id, :null=>false
      t.string    :service_url, :limit=>500
    end
  end
 
  def self.down
    drop_table :reports
  end
end
