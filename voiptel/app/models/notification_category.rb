class NotificationCategory < ActiveRecord::Base
  has_many :templates, :class_name => "NotificationTemplate", :foreign_key => "notification_category_id"
  has_many :notifications
end
