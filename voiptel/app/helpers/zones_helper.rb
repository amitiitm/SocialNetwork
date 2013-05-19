module ZonesHelper
  def carrier_choice(carrier_list, priority, selected, zone_id)
    # render :partial => "carrier", :locals => {:priority => priority, :selected => selected, :carriers => carrier_list}
    select("zone[#{zone_id}][carrier]", priority, carrier_list, {:include_blank => "---", :selected => selected })
  end
  
  def save_link(id)
    link_to_remote "Save", :url => {:action => "update_zone"}, :submit => "zone-#{id}"
  end
  
  def delete_link(id)
    link_to_remote "Delete", :url => {:action => "destroy_zone", :id => id}
  end
  
  def create_zone_form(zone)
    render  :partial => "zone_form", :locals => {:zone => zone, :row_id => zone.id,
            :carriers => @carriers, :selected => zone.selections}
  end
  
  def calculate_cost(buy, did, value, comission)    
    balance = value - (value * comission)
    termination_cost = (buy + did)
    minutes_for_balance = (balance / termination_cost).to_i
    sell_price = (value.to_f / minutes_for_balance)
  end

  def calculate_margin(sell_price, buy, did, value, comission)
    sell_price = sell_price || 0.0
    cost = calculate_cost(buy, did, value, comission)
    diff = sell_price - cost
    diff / cost
  end  
end
