class NotificationTypesController < ApplicationController
  def index
    @notification_types = NotificationType.find(:all, :order => "notification_category_id asc")
    resp
  end

  def new
    @notification_type = NotificationType.new
    resp
  end

  def edit
    @notification_type = NotificationType.find(params[:id])
    resp
  end

  def create
    @path = notification_types_path
    @notification_type = NotificationType.new(params[:notification_type])    
    resp @notification_type.save
  end
  
  def update
    @path = notification_types_path
    @notification_type = NotificationType.find(params[:id])
    resp @notification_type.update_attributes(params[:notification_type])
  end
  
  def destroy
    @path = notification_types_path
    @notification_type = NotificationType.find(params[:id]).destroy
  end
end
