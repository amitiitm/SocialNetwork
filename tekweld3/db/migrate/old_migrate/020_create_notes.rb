class CreateNotes < ActiveRecord::Migration
  def self.up
      create_table :notes do |t| 
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.string    :table_name,  :limit=>30
      t.integer   :trans_id
      t.integer   :user_id, :null=>false
      t.datetime  :date_added
      t.string    :subject,  :limit=>100
      t.string    :description,  :limit=>500
      t.string    :notes_type,   :limit=>1, :default=>'M'
      end
  end

  def self.down
     drop_table :notes
  end
end
