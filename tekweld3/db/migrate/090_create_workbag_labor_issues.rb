class CreateWorkbagLaborIssues < ActiveRecord::Migration
  def self.up
    create_table :workbag_labor_issues do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.integer   :workbag_id
      t.string    :trans_bk,      :limit => 4  , :null => false
      t.string    :trans_no,      :limit => 18 , :null => false
      t.timestamp :trans_date
      t.string    :account_period_code,    :limit => 8 , :null => false
      t.string    :serial_no,   :limit => 6
      t.string    :labor_type,   :limit => 25
      t.integer   :labor_id
      t.string    :labor_code,      :limit => 25
      t.string    :labor_description,      :limit => 25
      t.decimal   :cost, :precision=>12, :scale=>2
      t.decimal   :price, :precision=>12, :scale=>2
      t.decimal   :qty, :precision=>6, :scale=>2
      t.decimal   :total_cost, :precision=>12, :scale=>2
      t.decimal   :total_amt, :precision=>12, :scale=>2
      t.string    :remarks,      :limit => 100
    end
  end

  def self.down
    drop_table :workbag_labor_issues
  end
end
