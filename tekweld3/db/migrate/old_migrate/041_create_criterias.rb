class CreateCriterias < ActiveRecord::Migration
  def self.up
    create_table :criterias do |t|
      t.integer   :company_id, :null=>false
      t.integer   :created_by, :updated_by
      t.datetime  :created_at, :updated_at
      t.string    :update_flag, :limit=>1,:default=>'Y'
      t.string    :trans_flag, :limit=>1,:default=>'A'
      t.integer   :lock_version,  :default=>0
      
      t.string    :name, :limit=>50
      t.string    :criteria_type, :limit=>20
      t.string    :default_yn, :limit=>1, :default=>'N'
      t.integer   :user_id, :null=>true
      t.integer   :document_id, :null=>false
      
      t.string    :str1, :limit=>25
      t.string    :str2, :limit=>25
      t.string    :str3, :limit=>25
      t.string    :str4, :limit=>25
      t.string    :str5, :limit=>25
      t.string    :str6, :limit=>25
      t.string    :str7, :limit=>25
      t.string    :str8, :limit=>25
      t.string    :str9, :limit=>25
      t.string    :str10, :limit=>25
      t.string    :str11, :limit=>25
      t.string    :str12, :limit=>25
      t.string    :str13, :limit=>25
      t.string    :str14, :limit=>25
      t.string    :str15, :limit=>25
      t.string    :str16, :limit=>25
      t.string    :str17, :limit=>25
      t.string    :str18, :limit=>25
      t.string    :str19, :limit=>25
      t.string    :str20, :limit=>25
      t.string    :str21, :limit=>25
      t.string    :str22, :limit=>25
      t.string    :str23, :limit=>25
      t.string    :str24, :limit=>25
      t.string    :str25, :limit=>25

      t.datetime  :dt1
      t.datetime  :dt2
      t.datetime  :dt3
      t.datetime  :dt4
      t.datetime  :dt5
      t.datetime  :dt6
      t.datetime  :dt7
      t.datetime  :dt8
      t.datetime  :dt9
      t.datetime  :dt10

      t.decimal   :dec1, :precision=>12, :scale=>2
      t.decimal   :dec2, :precision=>12, :scale=>2
      t.decimal   :dec3, :precision=>12, :scale=>2
      t.decimal   :dec4, :precision=>12, :scale=>2
      t.decimal   :dec5, :precision=>12, :scale=>2
      t.decimal   :dec6, :precision=>12, :scale=>2
      t.decimal   :dec7, :precision=>12, :scale=>2
      t.decimal   :dec8, :precision=>12, :scale=>2
      t.decimal   :dec9, :precision=>12, :scale=>2
      t.decimal   :dec10, :precision=>12, :scale=>2

      t.decimal   :int1
      t.decimal   :int2
      t.decimal   :int3
      t.decimal   :int4
      t.decimal   :int5
      t.decimal   :int6
      t.decimal   :int7
      t.decimal   :int8
      t.decimal   :int9
      t.decimal   :int10

      t.string    :list1, :limit=>5
      t.string    :list2, :limit=>5
      t.string    :list3, :limit=>5
      t.string    :list4, :limit=>5
      t.string    :list5, :limit=>5
      t.string    :list6, :limit=>5
      t.string    :list7, :limit=>5
      t.string    :list8, :limit=>5
      t.string    :list9, :limit=>5
      t.string    :list10, :limit=>5

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

      t.string    :multiselect1, :limit=>200
      t.string    :multiselect2, :limit=>200
      t.string    :multiselect3, :limit=>200
      t.string    :multiselect4, :limit=>200
      t.string    :multiselect5, :limit=>200
      t.string    :multiselect6, :limit=>200
      t.string    :multiselect7, :limit=>200
      t.string    :multiselect8, :limit=>200
      t.string    :multiselect9, :limit=>200
      t.string    :multiselect10, :limit=>200

      t.string    :lookup_name, :limit =>25
      t.string    :whereclause, :limit =>500
      t.string    :default_request, :limit=>1,:default=>'N'
      
    end
  end

  def self.down
    drop_table :criterias
  end
end
