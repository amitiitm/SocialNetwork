puts "Setting Up Default Admin UI"
DefaultUi.connection.execute("TRUNCATE `default_uis`")

owner = "account_details"

DefaultUi.new(:partial_name => "portlet_account_info",
  :partial_location => "v2/accounts/ui/account_overview/portlet_account_info",
  :container => "left", :position => 1, :owner => owner).save

DefaultUi.new(:partial_name => "portlet_phones_and_dids",
  :partial_location => "v2/accounts/ui/account_overview/portlet_phones_and_dids",
  :container => "left", :position => 2, :owner => owner).save

DefaultUi.new(:partial_name => "portlet_sub_accounts",
  :partial_location => "v2/accounts/ui/account_overview/portlet_sub_accounts",
  :container => "middle", :position => 1, :owner => owner).save 

  
DefaultUi.new(:partial_name => "portlet_follow_ups",
  :partial_location => "v2/accounts/ui/account_overview/portlet_follow_ups",
  :container => "right", :position => 1, :owner => owner).save
  
AdminUser.all.each do |admin|
  DefaultUi.all.each do |dui|
    admin_ui = AdminUi.new
    admin_ui.position = dui.position
    admin_ui.container = dui.container
    admin_ui.partial_name = dui.partial_name
    admin_ui.partial_location = dui.partial_location
    admin_ui.owner = dui.owner
    admin_ui.default_ui = dui
    admin.admin_uis << admin_ui
  end
  admin.save
end