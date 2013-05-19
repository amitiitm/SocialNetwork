class CreateMenus < ActiveRecord::Migration
  def self.up
    create_table :menus do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version, :default=>0            
      t.string    :code, :limit=> 25, :null=>false
      t.string    :menu_name, :limit=>50
      t.integer   :moodule_id, :null=>false
      t.string    :menu_type, :limit=>1, :null=>false
      t.integer   :menu_id
      t.integer   :document_id
      t.integer   :sequence, :null=>false, :default=>0
    end
  end

  def self.down
    drop_table :menus
  end
end
