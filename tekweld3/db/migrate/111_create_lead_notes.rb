class CreateLeadNotes < ActiveRecord::Migration
  def self.up
    create_table :lead_notes do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.integer   :crm_lead_id
      t.string    :user_cd,   :limit => 250
      t.timestamp :note_date
      t.string    :note,   :limit => 1000
      t.string    :serial_no,   :limit => 6
    end
  end

  def self.down
    drop_table :lead_notes
  end
end
