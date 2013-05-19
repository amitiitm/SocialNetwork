class Memo < ActiveRecord::Base
  belongs_to :memoable, :polymorphic => true
  #belongs_to :contactable, :polymorphic => true
  
  belongs_to :assigned_to, :class_name => "AdminUser", :foreign_key => "assigned_to_id"
  belongs_to :created_by, :class_name => "AdminUser", :foreign_key => "created_by_id"
  belongs_to :followup_by, :class_name => "AdminUser", :foreign_key => "followup_by_id"
  belongs_to :memo_type
  belongs_to :memo_category

  has_many :memo_updates
  has_many :pbx_cdrs
  
  accepts_nested_attributes_for :memo_updates, :reject_if => proc {|atr| atr['create_record'] == "false"}
  
  before_validation :set_due_dates_for_followup
  
  validates_presence_of :assigned_to_id, :message => "Please assign the followup to someone!", :if => proc { |memo| memo.followup }
  validates_presence_of :content, :on => :create, :message => "Please write a breif memo!"
  validates_presence_of :followup_due, :message => "Please enter the followup date", :if => proc { |memo| memo.followup }
  
  before_save :set_memo_category
  before_save :set_success
  before_create :check_for_finished_followup

  attr_accessor :tmp_due_date, :tmp_due_hour, :tmp_due_minute, :tmp_due_baghali, :update_by_id, :tmp_success

  STATUS = [
    ["Call client", 1],
    ["Waiting for call", 2],
    ["Completed", 3]
  ]
  
  PRIORITIES = [
    ["Normal", 1],
    ["Important", 2],
    ["Urgent", 3]
  ]
  
  MEMO_FOR = [
    ["Accounts", "Account"],
    ["Cards", "Card"],
    ["Leads", "Lead"]
  ]
  
  CLOSED = 3
  
  STATUS_STRING = ["","Call client", "Waiting for call", "Completed"]
  
  def status_string
    STATUS_STRING[self.status]
  end
  
  def due_date
    if self.followup_due
      self.followup_due.strftime("%Y-%m-%d")
    else
      ""
    end    
  end
  
  def due_date=(val)
    self.tmp_due_date = val
  end
  
  def due_hour
    if self.followup_due
      h = self.followup_due.strftime("%I")
      (h.index("0") == 0) ? h[1..-1] : h
    else
      ""
    end
  end
  
  def due_hour=(val)
    self.tmp_due_hour = val
  end
  
  def due_minute
    if self.followup_due      
      self.followup_due.strftime("%M")
    else
      ""
    end
  end
  
  def due_minute=(val)
    self.tmp_due_minute = val
  end
  
  def due_baghali
    if self.followup_due
      self.followup_due.strftime("%p").downcase
    else
      ""
    end
  end
  
  def due_baghali=(val)
    self.tmp_due_baghali = val
  end
  
  def self.pariority_select_options
    [
      ["Normal", "1"],
      ["Important", "2"],
      ["Urgent", "3"]
    ]
  end
  
  private
  
  def baghali
    if self.followup
      if self.tmp_due_date.blank?
        errors.add('due_date', "Due date should not be blank")
      end
    end
  end
  
  def baghali2
    if self.followup
      if self.tmp_due_minute.blank? or self.tmp_due_hour.blank? or self.tmp_due_baghali.blank?
        errors.add('due_date_time', "Due time should not be blank")
      end
    end
  end
  
  def set_memo_category
    if self.memo_type_id
      self.memo_category_id = MemoType.find(self.memo_type_id).memo_category_id
    end
    true
  end
  
  def check_for_finished_followup
    if self.status == 3
      self.followup_date = Time.now
      self.followup_by_id = self.created_by_id
    end
    true
  end
  
  def nemoodi
    if self.status == 3
      if self.tmp_success.blank?
        errors.add('success', "Please indicate if you succeed?")
      else
        self.success = (self.tmp_success == "true") ? true : false
      end      
    end
    logger.info { "------------------------------ KOSHTI MANOOOOOOOOOOOO!!!!!!!" }
  end
  
  def set_success
    if not self.tmp_success.blank?
      self.success = (self.tmp_success == "true")? true : false
    end
    true
  end
  
  def set_due_dates_for_followup
    h = self.tmp_due_hour
    m = self.tmp_due_minute
    b = self.tmp_due_baghali
    if self.followup
      unless self.tmp_due_baghali.blank? and self.tmp_due_minute.blank? and self.tmp_due_hour.blank?
        if b == "pm"
          if h != "12"
            h = (h.to_i + 12).to_s
          end
        end
        if h.length == 1
          h = "0#{h}"
        end
        if m.length == 1
          m = "0#{m}"
        end
        d = "#{self.tmp_due_date} #{h}:#{m}:00 #{b}"  
        self.followup_due = Chronic.parse(d)
        logger.info { "TMP DATES: #{d} ---- followup: #{self.followup_due}" }
      end
    else
      self.followup_due = nil
    end
  end 
  
end
