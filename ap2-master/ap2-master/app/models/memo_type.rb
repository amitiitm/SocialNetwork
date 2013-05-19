class MemoType < ActiveRecord::Base
  belongs_to :memo_category
  has_many :memos
  
  has_one :template_memo_type
  has_many :notification_templates, :through => :template_memo_type
  
  attr_accessor :new_category
  
  before_save :check_for_new_category
  
  def has_template?(t)
    begin
      template = self.notification_templates.find(t.id)
      return true
    rescue Exception => e
      return false
    end    
  end
  
  private
  def check_for_new_category
    if self.memo_category_id == 0
      self.memo_category = MemoCategory.new(:category => self.new_category)
      self.memo_category.save
      self.memo_category_id = self.memo_category.id
    end
  end
end
