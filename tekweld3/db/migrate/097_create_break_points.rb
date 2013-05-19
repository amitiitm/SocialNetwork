class CreateBreakPoints < ActiveRecord::Migration
  def self.up
    create_table :break_points do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.string    :category_code,   :limit => 50
      t.string    :breakpoint1,   :limit => 50
      t.integer   :sold_amt
      t.integer   :cost
      t.integer   :total_qty
      t.integer   :JAN
      t.integer   :FEB
      t.integer   :MAR
      t.integer   :APR
      t.integer   :MAY
      t.integer   :JUN
      t.integer   :JUL
      t.integer   :AUG
      t.integer   :SEP
      t.integer   :OCT
      t.integer   :NOV
      t.integer   :DEC
      t.integer   :sequence
      
    end
  end

  def self.down
    drop_table :break_points
  end
end
