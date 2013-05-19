module MemoHelper
  def gooz_new_memo_path
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return send "new_#{$1}_memo_path"
      end
    end
    nil    
  end
  
  def gooz_edit_memo_path(model)
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return send "edit_#{$1}_memo_path", model
      end
    end
    nil    
  end

  def created_by(memo, msg = "N/A")
    if memo
      if memo.created_by
        memo.created_by.name
      else
        msg
      end
    end
  end
  
  def assigned_to(memo, msg = "N/A")
    if memo
      if memo.assigned_to
        return memo.assigned_to.name
      end
    end
    msg
  end
  
  def followup_by(memo, msg = "N/A")
    if memo
      if memo.followup_by
        return memo.followup_by.name
      end
    end
    msg
  end
  
  def followup_date(memo, msg = "N/A")
   if memo
     if memo.followup_date
       return (memo.followup_date.today?)? "<span class='red'>Today</span> at #{memo.followup_date.strftime('%H:%M')}" : user_date(memo.followup_date)
     end
   end
   msg
  end
  
  def followup_due_date(memo, msg = "N/A")
   if memo
     if memo.followup_due
       return user_date(memo.followup_due)
     end
   end
   msg
  end
  
end
