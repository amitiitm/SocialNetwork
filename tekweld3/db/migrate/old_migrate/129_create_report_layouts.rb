class CreateReportLayouts < ActiveRecord::Migration
  def self.up
    create_table :report_layouts do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.integer   :report_id ,  :null=>false
      t.string    :layout_type,  :limit=>1, :default=>'U'
      t.string    :name ,  :limit=>50         
    end
  end
 
  def self.down
    drop_table :report_layouts
  end
end
