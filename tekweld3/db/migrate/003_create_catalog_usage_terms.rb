class CreateCatalogUsageTerms < ActiveRecord::Migration
  def self.up
    create_table :catalog_usage_terms do |t|
      t.integer   :company_id,  :null => false, :default=>1
      t.integer   :created_by
      t.integer   :updated_by
      t.timestamp :created_at
      t.timestamp :updated_at
      t.string    :update_flag,  :limit => 1,    :default => "Y"
      t.string    :trans_flag,   :limit => 1,    :default => "A"
      t.integer   :lock_version,                 :default => 0
      t.string    :heading,      :limit => 100
      t.string    :paragraph,    :limit => 3000
      t.string    :link1_text,   :limit => 100
      t.string    :link1_url,    :limit => 100
      t.string    :link2_text,   :limit => 100
      t.string    :link2_url,    :limit => 100
      t.string    :link3_text,   :limit => 100
      t.string    :link3_url,    :limit => 100
      t.integer   :sequence
      t.string    :diaspark_default, :limit=>1, :default=>'Y'
    end
  end

  def self.down
    drop_table :catalog_usage_terms
  end
end
