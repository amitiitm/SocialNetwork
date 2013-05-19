class CreateJewelryUnitConversions < ActiveRecord::Migration
  def self.up
    create_table :jewelry_unit_conversions do |t|
      t.integer   :company_id,  :null => false
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version, :default => 0
      t.string    :item , :limit=>6
      t.string    :type , :limit=>4
      t.string    :from_unit , :limit=>4
      t.string    :to_unit , :limit=>4
      t.decimal   :factor, :precision=>13, :scale=>6
      t.string    :description , :limit=>40
    end
  end

  def self.down
    drop_table :jewelry_unit_conversions
  end
end
