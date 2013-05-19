class Main::MainCompany < ActiveRecord::Base
  establish_connection  'main_schema'
  include UserStamp
  include Dbobject
 
  validates     :code ,:presence => true
  validates_uniqueness_of  :code, :message => 'Company Code has aleady been taken.. '
end
