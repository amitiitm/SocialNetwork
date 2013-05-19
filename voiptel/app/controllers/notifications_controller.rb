class NotificationsController < ApplicationController
  
  def index
    @emailable = find_emailable
    @notifications = @emailable.notifications
    resp
  end
  
  def view
    @notification = Notification.find(params[:id])
    render :layout => false
  end
  
  def show
    @notification = Notification.find(params[:id])
    resp
  end
  
  def new
    @notification = Notification.new
    resp
  end
  
  def create
    @notification = Notification.new(params[:notification])
    @path = notifications_path
    resp @notification.save
  end
  
  def edit
    @notifications = Notification.find(params[:id])
    resp
  end
  
  def update
    @notification = Notification.find(params[:id])
    @path = notifications_path
    resp @notification.update_attributes(params[:notification])
  end
  
  def destroy
    @notification = Notification.find(params[:id])
    @path = notifications_path
    resp @notification.destroy
  end
  
  private
  def find_emailable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
