class UiSettingsController < ApplicationController
  def account_details
    cols = params[:cols]
    cols.keys.each do |k|
      position = 1
      cols[k].each do |i|
        ui = AdminUi.find(:first, :conditions => {:admin_user_id => session[:admin_user_id], :partial_name => i})
        if ui
          ui.position = position
          ui.container = k
          ui.save
        end
        position += 1
      end
    end
  end
end
