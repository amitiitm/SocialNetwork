f = File.new(ARGV[0], "r")
memo_type = ARGV[1]
while content = f.gets
  content.split("\r").each do |line|
    line = "#{line} "
    info = line.split("|")
    l = Lead.new
    l.admin_user_id = 0
    l.phone = info[0]
    
    status = info[1].strip.downcase
    
    if status == "d" or status == "r"
      l.do_not_call = true
    end
    
    #puts "#{status}: #{info[0]}"
    
    l.first_name = info[2].strip
    l.last_name = info[3].strip
    
    notes = info[4..-1]
    
    i = 0
    notes = notes.map {|n| i+=1; n = "Note #{i}: #{n}"}
    notes = notes.join("\n")
    
    if l.phone.length == 10
      l.phone = "1#{l.phone}"
    end
    l.set_lead_info
    l.save    
    
    if not status.blank? and status != "d" and status != "r"
      m = Memo.new
      m.content = notes
      m.followup = true
      m.followup_due = (Time.now + 30.days).beginning_of_day
      m.followup_date = Time.now.beginning_of_day
      m.assigned_to_id = 0
      m.followup_by_id = 0
      m.memoable_id = l.id
      m.memoable_type = "Lead"
      m.created_by_id = 0
      m.memo_type_id = 1
      m.memo_category_id = 1
      
      case status
        when "co"
          puts "success!"
          m.success = true
          m.status = 3
        when "n"          
          m.success = false
          m.status = 3          
        when "c"
          m.status = 1
      end
      if not m.save
        puts "could not save"
      end
    end    
  end
end