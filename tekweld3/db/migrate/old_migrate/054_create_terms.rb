class CreateTerms < ActiveRecord::Migration
  def self.up
    create_table :terms do |t| 
        t.column :code, :string, :limit=>25, :null=>false, :default=>:id
        t.column :company_id, :int, :null=>false
        t.column :created_by, :int 
        t.column :created_at, :datetime
        t.column :updated_by, :int
        t.column :updated_at, :datetime
        t.column :trans_flag, :string,:limit=>1,:default=>'A'
        t.column :update_flag, :string,:limit=>1,:default=>'Y'
        t.column :lock_version, :int, :default=>0
        t.column :name, :string,:limit=>50
        t.column :disc_per, :decimal,:precision=>6, :scale=>2
        t.column :disc_days, :int
        t.column :pay1_per, :decimal,:precision=>6, :scale=>2 
        t.column :pay1_days, :int
        t.column :pay2_per, :decimal,:precision=>6, :scale=>2 
        t.column :pay2_days, :int
        t.column :pay3_per, :decimal,:precision=>6, :scale=>2 
        t.column :pay3_days, :int
        t.column :pay4_per, :decimal,:precision=>6, :scale=>2 
        t.column :pay4_days, :int
        t.column :pay5_per, :decimal,:precision=>6, :scale=>2 
        t.column :pay5_days, :int
        t.column :pay6_per, :decimal,:precision=>6, :scale=>2 
        t.column :pay6_days, :int
        t.column :pay1_date, :datetime 
        t.column :pay2_date, :datetime 
        t.column :pay3_date, :datetime 
        t.column :pay4_date, :datetime 
        t.column :pay5_date, :datetime 
        t.column :pay6_date, :datetime 
    end
  end

  def self.down
    drop_table :terms
  end
end
