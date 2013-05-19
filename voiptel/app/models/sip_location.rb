class SipLocation < ActiveRecord::Base
  establish_connection DB_OPENSIPS
  set_table_name "location"
  
  belongs_to :sip_account, :class_name => "SipAccount", :primary_key => "username", :foreign_key => "username"
end