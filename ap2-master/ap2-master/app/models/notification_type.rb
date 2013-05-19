class NotificationType < ActiveRecord::Base
  belongs_to :notification_category
  #has_many :notifications
  
  attr_accessor :new_category
  validates_presence_of :name, :message =>  "Type can't be blank"
  
  before_save :check_for_new_category
  
  private
  def check_for_new_category
    if self.notification_category_id == 0
      self.notification_category = NotificationCategory.new(:name => self.new_category)
      self.notification_category.save
      self.notification_category_id = self.notification_category.id
    end
  end
  
end
