class VMBox < ActiveRecord::Base
  set_table_name "voicemail"
  belongs_to :account
  belongs_to :sip_account, :class_name => "SipAccount", :foreign_key => "subscriber_id"  
  alias_attribute :full_name, :fullname
  
  before_save :set_stamp
  
  def self.primary_key
    "uniqueid"
  end
  
  class << self
    def instance_method_already_implemented?(method_name)
      return true if method_name == 'callback'
      super
    end
  end
  
  private
  def set_stamp
    self.stamp = self.updated_at
  end
end
