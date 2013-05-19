class Notification < ActiveRecord::Base
  belongs_to :emailable, :polymorphic => true
  belongs_to :category, :class_name => "NotificationCategory", :foreign_key => "notification_category_id"
  
  def from
    "#{self.from_name} #{self.from_address}"
  end
  
  def to
    "#{self.to_name} #{self.to_address}"
  end
  
end
