class CreateLookups < ActiveRecord::Migration
  def self.up
    create_table :lookups do |t|
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.string    :name,  :limit=>50
      t.string    :table_name,  :limit=>50
      t.string    :whereclause,  :limit=>250
      t.decimal   :version, :precision=>10, :scale=>0
    end
  end

  def self.down
    drop_table :lookups
  end
end
