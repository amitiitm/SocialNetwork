class VM < ActiveRecord::Base
  set_table_name "voicemail_data"
  belongs_to :account
  belongs_to :vm_box, :class_name => "VMBox", :foreign_key => "origmailbox"
end
