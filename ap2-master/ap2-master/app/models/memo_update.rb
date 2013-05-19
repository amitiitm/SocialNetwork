class MemoUpdate < ActiveRecord::Base  
  belongs_to :followup_by, :class_name => "AdminUser", :foreign_key => "admin_user_id"
  belongs_to :memo
  
  has_many :memo_update_notifications
  has_many :notifications, :through => :memo_update_notifications
  
  validates_presence_of :admin_user_id, :message => "Baghaliiiiiiii"
  validates_presence_of :contact_type, :message => "Please select the contact method"
  validates_presence_of :result, :message => "Please select the contact result"
  validates_presence_of :content, :message => "Please write a short memo for your followup"
  
  before_save :set_memo_followup_stuff
  attr_accessor :create_record
  
  CONTACT_TYPES = [
    ["Outbound", 1],
    ["Inbound", 2],
    ["Outbound +  Email", 4],
    ["Inbound + Email", 5],
    ["Email Only", 3]
  ]
  
  RESULTS = [
    ["Answered", 1],
    ["Answered - Contact later", 2],
    ["Left VM", 3],
    ["Not Answered", 4],
  ]
  
  def set_memo_followup_stuff
    self.memo.followup_by_id = self.admin_user_id
    self.memo.followup_date = Time.now
    self.memo.save
    true
  end  
end
