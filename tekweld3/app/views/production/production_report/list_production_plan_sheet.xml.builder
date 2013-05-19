xml.instruct! :xml, :version=>"1.0" 

xml.sales_orders{
  count = 0;count1=0;count2=0;count3=0;count4=0;count5=0;count6=0
  for order_receive in @orderreceive
    xml.sales_order do
      column_value = format_column(order_receive.trans_date)
      xml.trans_date(column_value)
      xml.orderreceived_flag(order_receive.orderreceived_flag)
      if (@orderentry[count] and (column_value == @orderentry[count].trans_date.to_time.strftime('%m/%d/%Y'))) 
        xml.orderentrycomplete_flag(@orderentry[count].orderentrycomplete_flag)
        count += 1
      end  
      if (@orderqc[count1] and (column_value == @orderqc[count1].trans_date.to_time.strftime('%m/%d/%Y')))      
        xml.orderqcstatus_flag(@orderqc[count1].orderqcstatus_flag)
        count1 += 1        
      end
      if (@paperproof[count2] and (column_value == @paperproof[count2].trans_date.to_time.strftime('%m/%d/%Y')))
        xml.paper_proof_flag(@paperproof[count2].paper_proof_flag)
        count2 += 1
      end
      if (@artworkreceive[count3] and (column_value == @artworkreceive[count3].trans_date.to_time.strftime('%m/%d/%Y')))
        xml.artworkreceived_flag(@artworkreceive[count3].artworkreceived_flag) 
        count3 += 1
      end
      if (@artworkreviewed[count4] and (column_value == @artworkreviewed[count4].trans_date.to_time.strftime('%m/%d/%Y')))     
        xml.artworkreviewed_flag(@artworkreviewed[count4].artworkreviewed_flag)
        count4 += 1        
      end
      if (@artworkapprovedbycust[count5] and (column_value == @artworkapprovedbycust[count5].trans_date.to_time.strftime('%m/%d/%Y')))
        xml.artworkapprovedbycust_flag(@artworkapprovedbycust[count5].artworkapprovedbycust_flag)
        count5 += 1        
      end
      if (@accountreviewed[count6] and (column_value == @accountreviewed[count6].trans_date.to_time.strftime('%m/%d/%Y')))
        xml.accountreviewed_flag(@accountreviewed[count6].accountreviewed_flag)
        count6 += 1
      end
#      xml.orderentrycomplete_flag("") if !@orderentry[count]
#      xml.orderqcstatus_flag("") if !@orderqc[count1]
#      xml.paper_proof_flag("") if !@paperproof[count]
#      xml.artworkreceived_flag("") if !@artworkreceive[count]
#      xml.artworkreviewed_flag("") if !@artworkreviewed[count]
#      xml.artworkapprovedbycust_flag("") if !@artworkapprovedbycust[count]
#      xml.accountreviewed_flag("") if !@accountreviewed[count]
    end
  end
}
