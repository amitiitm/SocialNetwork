class CreateSequences < ActiveRecord::Migration
  def self.up
     create_table :sequences do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.string    :book_cd,   :limit=>4
      t.string    :book_nm,   :limit=>30
      t.string    :book_lno,  :limit=>11
      t.string    :docu_typ,  :limit=>10
      t.string    :default_bk,  :limit=>1
      t.string    :link_bk1,  :limit=>4
      t.string    :link_bk2,  :limit=>4
      t.string    :lno_flag,  :limit=>1
      t.datetime  :lno_date
      t.string    :edit_flag,  :limit=>1
      t.string    :table_nm,  :limit=>40 
      t.integer   :user_id
      t.string    :prod_trans_type,  :limit=>4
     end  
  end

  def self.down
    drop_table :sequences
  end
end
