module ReportsHelper
  def callers_name(cdr)    
  end

	def zone(cdr)
	  zone = nil
    if cdr.zone
      zone = cdr.zone
    #elsif cdr.old_zone
    #  zone = cdr.old_zone
    end
    
    if zone
      zone.name
    else
      "---"
    end
	end
	
	def months
	end
	
	
	def pcap(cdr)
	 moment = cdr.date.strftime("%H%M%S")
	 date = cdr.date.strftime("%Y%m%d")
	 hour = cdr.date.strftime("%H")
	 pcap_file = `find /openfo/traces/traces/#{date}/#{hour} | grep #{moment}`.gsub("\n","")
	 unless pcap_file.blank?
	   return link_to("Link", "http://sip.openfo.com#{pcap_file}")
   else
     return ""
   end
	end
	
	def xml_item(cdr)
	 Rails.cache.fetch("cdr_#{cdr.id}", :expires_in => 24.hours) do
	   render(:partial => 'xml_item', :locals => {:cdr => cdr})
   end
	end

	def carrier(c)
		if(c)
			c.name
		else
			"---"
		end
	end
  
  def duration(seconds)    
    m = seconds / 60
    m = '0'+m.to_s if m < 10
    s = seconds % 60
    s = '0'+s.to_s if s < 10
      "#{m}:#{s}"
  end
  
  def has_feedback(cdr)
  	if cdr.feedback
  		return true
  	end  	
  	return false
  end
  
  def has_recording(cdr)
	 if File.exists?("/openfo/recordings/#{cdr.uniqueid}.wav")
	   return true
	 end
	
	 return false
	end
  
  def actions(cdr)
    link_to_function "Session Log", "Popup.open({url: '/reports/session_log/#{cdr.id}', width:750, height:350});"
  end
  
  # def country_name(phone_number)
  #   country = CountryCode.new
  #   country.country_name(phone_number)
  # end
  
  def cid(cdr)
    if cdr.phone
      number_to_phone(cdr.phone.complete_phone_number, :area_code => true)      
    else
      cdr.src
    end    
  end
  
  def did(cdr)
    if cdr.did
      cdr.did.number
    else
      "---"
    end
  end
  
  def did_provider(did)
    #if did
    #  if (did.id >= 49)
    #    return "MixMeeting"
    #  end
    #  if (did.id >= 47)
    #    return "VoiceStep"
    #  end
    #  return "DIDX"      
    #else
    #  "DIDX"
    #end
		if did
    	did.did_provider.name
		else
			"---"
		end
  end
  
  def name(cdr)
    if cdr.account.account_type == 2
      return cdr.account.business_name
    end
    if cdr.user
      cdr.user.name
    else
      "---"
    end
  end
end
