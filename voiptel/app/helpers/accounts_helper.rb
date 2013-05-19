module AccountsHelper

  def set_sort_icon(flag, sort_order)
    return "asc" unless flag
    sort_order == 'desc' ? 'asc' : 'desc'
  end

  def account_header(params, header,attr, advance_search)
    if advance_search
      (link_to header, accounts_path(:sort => attr, :limit => @limit, :size => @size, :page => @page, :sort_order => set_sort_icon(true, @sort_order)), :class =>'top_header',:remote => true)
    else
      header
    end
  end

  def display_tmp_password(user)
    unless user.auth_user
      return " | User has no login"
    end

    if user.auth_user.tmp_password
      return " | Tmp pass: #{user.auth_user.tmp_password.password}"
    else
      return ""
    end
  end

  def add_another_phone(counter)
    if counter == 0
      my_partial = escape_javascript render(:partial => "phone_line")
      dom_id = "phones"
      mark_new = 'true'
    else
      my_partial = escape_javascript render(:partial => "phone", :locals => {:form_name => "phone", :baghali => false})
      dom_id = "phones-#{counter}"
      mark_new = 'false'
    end

    link_to_function 'Add Another Phone', "form.add('#{my_partial}' , '#{dom_id}', #{mark_new})"
  end

  def add_another_caller()
    link_to_remote "Add Another Caller", :url => {:action => "new_caller"}
  end

  def show_last_activity(account)
    if account.follow_ups.size > 0
      last = account.follow_ups.last
      if last.last_follow_up_id
        f = FollowUp.find(last.last_follow_up_id)
        #return link_to("View", {:controller => "followup", :action => "last_activity", :id => last.last_follow_up_id}, {:class => "tooltip", :title => "salam"})
        return raw "<span class='tooltip' title='#{last.note.gsub("'", "")}'>#{last.follow_up_action.name}</span>"
      else
        return "N/A"
      end
    else
      return "N/A"
    end
  end

  def next_action(account)
    if account.follow_ups.size > 0
      last = account.follow_ups.last
      #return link_to(last.follow_up_action.name, {:controller => "followup", :action => "next_action", :id => last.id}, {:class => "next_action"})
      return raw "<span class='tooltip' title='#{last.note.gsub("'", "")}'>#{last.follow_up_action.name}</span>"
    else
      return "N/A"
    end
  end

  def auto_recharge(account)
    auto_recharge = ""
    if account.auto_recharge
      auto_recharge = image_tag("icons/auto-rech.png", :style => "vertical-align:text-bottom") + " #{account.threshold}/#{account.recharge_amount}"
    else
      auto_recharge = 'Off'
    end
    raw auto_recharge
  end

  def sub_accounts(account)
    sub_accounts = ""
    users = account.users.count - 1
    if users > 0
      sub_accounts = " | " + image_tag("icons/group.png", :style => "vertical-align:text-bottom") + " #{users}"
    end
    raw sub_accounts
  end

  def na_due_date(account)
    if account.follow_ups.size > 0
      user_date account.follow_ups.last.action_date
    else
      return "N/A"
    end
  end

  def last_contact_by(account)
    if account.follow_ups.size > 0
      if account.follow_ups.last.admin_user
        account.follow_ups.last.admin_user.name
      else
        "---"
      end
    else
      return "N/A"
    end
  end

  def shafang
    link_to_remote "Add Another Caller", :url => {:action => "shafang"}
  end

  def account_holder(id)
    begin
      user = User.find(id)
      return user.first_name + " " + user.last_name
    rescue Exception => e
      return "---"
    end
  end

  def account_name(account)

  end

  def display_ratecenter(area_code_info)
    if area_code_info
      unless area_code_info.ratecenter.blank?
        area_code_info.ratecenter
      else
        area_code_info.coverage_area_name
      end
    else
      return ""
    end
  end

  def remove_phone
    link_to_function "Remove", "mark_for_remove(this)", :id => "remove"
  end

  def rremove_phone
    link_to_function "Remove", "$(this).up().remove()", :id => "remove"
  end

  def phone_type(phone)
    if phone.phone_type == 1
      return " (H)"
    elsif phone.phone_type == 2
      return " (M)"
    else
      return " (W)"
    end
  end

  def expire_date(account)
    date = date_email_sent_on(account)
    if date
      date + 2592000
    else
      "-"
    end
  end

  def email_sent_on(account)
    date = date_email_sent_on(account)
    if date
      date
    else
      "Email Not Sent"
    end
  end

  def get_rate_center(country_code, area_code, phone_number)
    if country_code == "1"
      rate_center = Npanxx.find_by_npa_and_nxx(area_code, phone_number[0..2])
      if rate_center
        return rate_center.rate_center.rate_center
      end
    end
    "<span id='redred'>NOT FOUND</span>"
  end

  def check_available_did(phone)
    if phone.country_code == "1"
      npa = phone.area_code
      nxx = phone.phone_number[0..2]
      phone_npanxx = Npanxx.find(:first, :conditions => {:npa => npa, :nxx => nxx})
      if phone_npanxx
        #rate_centers = Npanxx.find(:all, :conditions => {:rate_center_id => phone_npanxx.rate_center.id, :npa => npa})
        dids = Did.find(:all, :conditions => ["number like ? and rate_center_id=?", "1#{npa}%", phone_npanxx.rate_center.id])
        if dids.length > 0
          locations = DidRateCenterLocation.find(:all, :conditions => {:npa => npa, :rate_center_id => phone_npanxx.rate_center.id})
          return_value = ""
          for location in locations
            return_value += distance(location.lat, location.long, phone_npanxx.latitude, phone_npanxx.longitude).to_s + " miles & "
          end
          return_value[0..-3]
        else
          "<span id='redred'>NO</span>"
        end
      else
        "<span id='redred'>NO</span>"
      end
    end
  end

#link_to_remote(number_to_phone(phone.complete_phone_number, :area_code => true), :url => {:controller => "service", :action => "call", :id => phone.complete_phone_number})
# 
  def display_assigned_did(phone)
    if phone.assigned_did
      link_to_remote(number_to_phone(phone.complete_phone_number, :area_code => true), :url => {:controller => "service", :action => "call", :id => phone.complete_phone_number}) + " assigned to ->" +
          link_to_remote(number_to_phone(phone.assigned_did.did.number, :area_code => true), :url => {:controller => "service", :action => "call", :id => phone.assigned_did.did.number}) +
          " (#{calculate_distance_from_rate_center(phone)} miles)"
    else
      link_to_remote(number_to_phone(phone.complete_phone_number, :area_code => true), :url => {:controller => "service", :action => "call", :id => phone.complete_phone_number}) + " not assigned."
    end
  end

  def display_assigned_did2(phone)
      number,is_permanent = PhoneDidHandler.get_phone_lan phone
      if is_permanent
          link_to_remote(number_to_phone(number, :area_code => true), :url => {:controller => "service", :action => "call", :id => number})
      else
          "<a href="">#{number_to_phone(number, :area_code => true)}</a> (Temporary Access Number)"
      end

#    if phone.assigned_did && (phone.assigned_did.did.active == 1 || phone.assigned_did.did.active == true)
#      link_to_remote(number_to_phone(phone.assigned_did.did.number, :area_code => true), :url => {:controller => "service", :action => "call", :id => phone.assigned_did.did.number}) +
#          " (#{calculate_distance_from_rate_center(phone)} miles)"
#    else
#      # "<span class='red'>Not assigned</span>"
#      # "<a href="">1(888) 221-9265</a> (Temporary Access Number)"
#        if phone.area_code_info
#            rc = RateCenter.find_by_rate_center(phone.area_code_info.ratecenter)
#            cond = "npa = #{phone.area_code_info.npa} AND rate_center_id = #{rc.id}"
#                npanxx = Npanxx.find(:all, :conditions => cond)
#            cond_1 = "active = 1 AND area_code = #{phone.area_code_info.npa} AND rate_center = '#{phone.area_code_info.ratecenter}'"
#                did_1 = Did.find(:all, :conditions => cond_1)
#            if did_1.count > 0
#                "<a href="">#{number_to_phone(did_1[0].number, :area_code => true)}</a>"
#            else
#                if phone.type_name_short == "M"
#                    cond_2 = "active = 1 AND area_code = #{phone.area_code_info.npa} AND rate_center != '#{phone.area_code_info.ratecenter}'"
#                        did_2 = Did.find(:all, :conditions => cond_2)
#                    if did_2.count > 0
#                        "<a href="">#{number_to_phone(did_2[0].number, :area_code => true)}</a>"
#                    else
#                        "<a href="">1(949) 202-1009</a> (Temporary Access Number)"
#                    end
#                else
#                    "<a href="">1(888) 221-9265</a> (Temporary Access Number)"
#                end
#            end
#        else
#            if phone.type_name_short == "M"
#                "<a href="">1(949) 202-1009</a> (Temporary Access Number)"
#            else
#                "<a href="">1(888) 221-9265</a> (Temporary Access Number)"
#            end
#        end
#    end
  end

  def did_rate_center_info(phone)
    if phone.assigned_did
      if phone.assigned_did.did.area_code_info
        "#{phone.assigned_did.did.area_code_info.ratecenter}" +
            " (#{calculate_distance_from_rate_center(phone)} miles)"
      end
    else
      "<span id='redred'>- - -</span>"
    end
  end

  private

  def date_email_sent_on(account)
    user = User.find(account.account_holder_id)
    notification = user.notifications.find(:first, :conditions => {:notification_type_id => 1})
    if notification
      return notification.sent_on
    end
    false
  end

  def calculate_distance_from_rate_center(phone)
    if phone.area_code_info and phone.assigned_did.did.area_code_info
      distance(phone.area_code_info.lat, phone.area_code_info.long, phone.assigned_did.did.area_code_info.lat, phone.assigned_did.did.area_code_info.long)
    end
  end

  def to_rad(degree)
    ((degree * Math::PI) / 180).to_f
  end

  def distance(lat1, long1, lat2, long2)
    lat1 = lat1.to_f
    long1 = long1.to_f
    lat2 = lat2.to_f
    long2 = long2.to_f
    r = 6371 / 1.609344
    lat = to_rad((lat2 - lat1))
    long = to_rad((long2 - long1))
    a = (Math.sin(lat/2) * Math.sin(lat/2)) + Math.cos(to_rad(lat1)) * Math.cos(to_rad(lat2)) * Math.sin(long/2) * Math.sin(long/2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    d = r * c
    number_with_precision(d)
  end
end
