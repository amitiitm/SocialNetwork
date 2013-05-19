class CreateWorkbagStages < ActiveRecord::Migration
  def self.up
    create_table :workbag_stages do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.string    :code,      :limit => 25
      t.string    :name,      :limit => 50
      t.string    :onhand_stage,      :limit => 1
      t.string   :receive_stage,      :limit => 1
      t.string   :close_stage,      :limit => 1
      t.integer   :sequence_no
      
    end
  end

  def self.down
    drop_table :workbag_stages
  end
end

