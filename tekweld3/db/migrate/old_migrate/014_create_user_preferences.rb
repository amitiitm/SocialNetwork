class CreateUserPreferences < ActiveRecord::Migration
  def self.up
    create_table :user_preferences do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version,  :default=>0
      t.integer   :user_id, :null=>false
      t.integer   :document_id, :null=>false
      t.string    :string1, :limit=>50
      t.string    :string2, :limit=>50
      t.string    :string3, :limit=>50
      t.string    :string4, :limit=>50
      t.string    :string5, :limit=>50
      t.string    :string6, :limit=>50
      t.string    :string7, :limit=>50
      t.string    :string8, :limit=>50
      t.string    :string9, :limit=>50
      t.string    :string10, :limit=>50
      t.string    :string11, :limit=>50
      t.string    :string12, :limit=>50
      t.string    :string13, :limit=>50
      t.string    :string14, :limit=>50
      t.string    :string15, :limit=>50
      t.string    :string16, :limit=>50
      t.string    :string17, :limit=>50
      t.string    :string18, :limit=>50
      t.string    :string19, :limit=>50
      t.string    :string20, :limit=>50
      t.datetime  :date1
      t.datetime  :date2
      t.datetime  :date3
      t.datetime  :date4
      t.datetime  :date5
      t.datetime  :date6
      t.datetime  :date7
      t.datetime  :date8
      t.datetime  :date9
      t.datetime  :date10
      t.decimal   :decimal1, :precision=>12, :scale=>2
      t.decimal   :decimal2, :precision=>12, :scale=>2
      t.decimal   :decimal3, :precision=>12, :scale=>2
      t.decimal   :decimal4, :precision=>12, :scale=>2
      t.decimal   :decimal5, :precision=>12, :scale=>2
      t.decimal   :decimal6, :precision=>12, :scale=>2
      t.decimal   :decimal7, :precision=>12, :scale=>2
      t.decimal   :decimal8, :precision=>12, :scale=>2
      t.decimal   :decimal9, :precision=>12, :scale=>2
      t.decimal   :decimal10, :precision=>12, :scale=>2
      t.string    :list1, :limit=>50
      t.string    :list2, :limit=>50
      t.string    :list3, :limit=>50
      t.string    :list4, :limit=>50
      t.string    :list5, :limit=>50
      t.string    :list6, :limit=>50
      t.string    :list7, :limit=>50
      t.string    :list8, :limit=>50
      t.string    :list9, :limit=>50
      t.string    :list10, :limit=>50
      t.string    :all1, :limit=>1
      t.string    :all2, :limit=>1
      t.string    :all3, :limit=>1
      t.string    :all4, :limit=>1
      t.string    :all5, :limit=>1
      t.string    :all6, :limit=>1
      t.string    :all7, :limit=>1
      t.string    :all8, :limit=>1
      t.string    :all9, :limit=>1
      t.string    :all10, :limit=>1
    end
  end

  def self.down
    drop_table :user_preferences
  end
end
