class FollowupController < ApplicationController
  def new
  end

  def create
    date = params[:date]
    followup = FollowUp.new(params[:follow_up])
    followup.action_date = Chronic.parse("#{date[:year]}-#{date[:month]}-#{date[:day]} #{date[:hour]}:#{date[:minute]}")
    followup.last_follow_up_id = (followup.last_follow_up_id == -1)? nil : followup.last_follow_up_id
    followup.admin_user_id = session[:admin_user_id]
    followup.save
    @id = params[:id]
  end
  
  def last_activity
    @id = params[:id]
    @followup = FollowUp.find(@id)
  end
  
  def next_action
    @id = params[:id]
    @followup = FollowUp.find(@id)
  end

  def update
  end

  def edit
  end

  def save
  end

  def delete
  end

end
