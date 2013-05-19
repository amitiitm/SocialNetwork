class CreateMeltingStageMaster < ActiveRecord::Migration
  def self.up
    create_table :melting_stage_master do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.string    :stage_code,   :limit => 50
      t.string    :stage_name,   :limit => 50
      t.string    :sequence_no,  :limit => 50
    end
  end

  def self.down
    drop_table :melting_stage_master
  end
end