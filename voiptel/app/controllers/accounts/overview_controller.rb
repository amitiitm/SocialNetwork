class Accounts::OverviewController < ApplicationController
  layout nil
  def index
    @account = Account.find(params[:account_id])
    @ui_left = current_admin_user.admin_uis.owner("account_details").container("left")
    @ui_middle = current_admin_user.admin_uis.owner("account_details").container("middle")
    @ui_right = current_admin_user.admin_uis.owner("account_details").container("right")
  end
end
