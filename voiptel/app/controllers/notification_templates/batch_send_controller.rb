class NotificationTemplates::BatchSendController < ApplicationController
  def create
    Resque.enqueue(NotificationMakerJob, params[:notification_template_id])
    resp
  end
end
