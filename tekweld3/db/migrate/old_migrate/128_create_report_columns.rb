class CreateReportColumns < ActiveRecord::Migration
  def self.up
    create_table :report_columns do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.integer   :report_id , :null=>false
      t.string    :column_name , :limit=>50
      t.string    :column_label , :limit=>100
      t.string    :column_datatype , :limit=>4
      t.string    :column_textalign, :limit=>1, :default=>'L'
      t.integer   :column_width 
      t.string    :sortdatatype ,  :limit=>4
      t.string    :isgroupable,  :limit=>1, :default=>'N'     
      t.string    :isdrilldowncolumn , :limit=>1, :default=>'N'     
    end
  end
  def self.down
    drop_table :report_columns
  end
end
