class CreateMainSequences < ActiveRecord::Migration
  def self.up
    create_table :main_sequences do |t|
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.string    :docu_lno,  :limit=>11
      t.string    :docu_typ,  :limit=>10
      t.datetime  :lno_date
    end
  end

  def self.down
    drop_table :main_sequences
  end
end
