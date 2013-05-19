class CreateLabors < ActiveRecord::Migration
  def self.up
    create_table :labors do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.string    :labor_type,   :limit => 25
      t.string    :code,      :limit => 25
      t.string    :description,      :limit => 50
      t.decimal   :cost, :precision=>10, :scale=>2
      t.decimal   :price, :precision=>12, :scale=>2
      t.decimal   :qty, :precision=>10, :scale=>2
      t.string    :remarks,      :limit => 255
    end
  end

  def self.down
    drop_table :labors
  end
end
