class Accounts::FollowUpsController < ApplicationController
  def create
    date = params[:date]
    followup = FollowUp.new(params[:follow_up])
    followup.account_id = params[:account_id]
    followup.action_date = Chronic.parse("#{date[:year]}-#{date[:month]}-#{date[:day]} #{date[:hour]}:#{date[:minute]}")
    followup.last_follow_up_id = (followup.last_follow_up_id == -1)? nil : followup.last_follow_up_id
    followup.admin_user_id = session[:admin_user_id]
    followup.save
    @id = params[:id]
  end
end
