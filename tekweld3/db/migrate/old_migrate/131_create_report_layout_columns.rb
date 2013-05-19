class CreateReportLayoutColumns < ActiveRecord::Migration
  def self.up
    create_table :report_layout_columns do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.integer   :report_layout_id,  :null=>false
      t.integer   :report_column_id, :null=>false
      t.string    :isgroup, :limit=>1 , :default=>'N'     
      t.integer   :group_level, :null=>true
      t.string    :istotal, :limit=>1 , :default=>'N'     
      t.string    :isvisible,  :limit=>1 , :default=>'Y'        
      t.integer   :sort_sequence
      t.integer   :column_sequence
    end
  end

  def self.down
    drop_table :report_layout_columns
  end
end
