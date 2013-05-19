class Sales::SalesOrderCancelCrud
include General

#Sales OrderCancel services  
def self.list_order_cancels(doc)
  criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
  Sales::SalesOrderCancel.active.find(:all,
                    :joins => "join customers on customers.id = sales_order_cancels.customer_id",
                    :conditions => ["( sales_order_cancels.company_id = ?) AND
                                    (customers.code between ? and ? AND (0 =? or customers.code in (?))) AND
                                    (trans_no between ? and ? AND (0 =? or trans_no in (?))) AND
                                    (trans_date between ? and ? ) AND
                                    (account_period_code between ? and ? AND (0 =? or account_period_code in (?)))
                                    " ,criteria.company_id,criteria.str1,criteria.str2,criteria.multiselect1.length, criteria.multiselect1,
                                     criteria.str3, criteria.str4,criteria.multiselect2.length, criteria.multiselect2, 
                                     criteria.dt1, criteria.dt2,
                                     criteria.str5, criteria.str6,criteria.multiselect3.length, criteria.multiselect3],
                    :order => "trans_date, trans_no"
  )
end

def self.list_open_order_cancels(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
    Sales::SalesOrderCancel.active.find(:all,
                      :select=>'b.*, (b.item_qty - b.clear_qty) as open_qty, 
                                catalog_items.taxable as taxable,catalog_items.image_thumnail as image_thumnail, catalog_items.packet_require_yn as packet_require_yn,
                                sales_order_cancels.discount_per as hdr_discount_per, 
                                sales_order_cancels.discount_amt as hdr_discount_amt, 
                                sales_order_cancels.tax_per as hdr_tax_per, 
                                sales_order_cancels.tax_amt as hdr_tax_amt ',
                      :joins=>' join sales_order_cancel_lines b on b.sales_order_cancel_id = sales_order_cancels.id 
                               join catalog_items on catalog_items.id = b.catalog_item_id',
                      :conditions => ["b.sales_order_cancel_id = sales_order_cancels.id and
                                        b.item_qty > b.clear_qty and
                                        b.trans_flag='A' and
                                        ( sales_order_cancels.company_id = ?) AND
                                        sales_order_cancels.customer_id between ? and ?
                                      " ,criteria.company_id,criteria.int1,criteria.int2],
                      :order => "sales_order_cancels.trans_date, sales_order_cancels.trans_no, b.serial_no"
    )
end

def self.show_order_cancel(order_cancel_id)
  Sales::SalesOrderCancel.find_all_by_id(order_cancel_id)
end
  
def self.create_order_cancels(doc)
 order_cancels = [] 
 (doc/:sales_order_cancels/:sales_order_cancel).each{|order_cancel_doc|
   order_cancel = create_order_cancel(order_cancel_doc)
   order_cancels <<  order_cancel if order_cancel
  }
  order_cancels
end

def self.create_order_cancel(doc)
  order_cancel = add_or_modify_order_cancel(doc) 
  order_cancel.generate_trans_no('SAOIOH') if order_cancel.new_record?
  order_cancel.apply_header_fields_to_lines  
  order_cancel.apply_line_fields_to_header  
  return  if !order_cancel
  ref_hdrs, ref_lines = order_cancel.run_sales_posting()
  save_proc = Proc.new{
    if order_cancel.new_record?
      order_cancel.save!  
    else
      order_cancel.save! 
      order_cancel.sales_order_cancel_lines.save_line
    end
    #save reference transactions
    ref_lines.each{|ref_line|
      ref_line.save!
    }
    ref_hdrs.each{|ref_hdr|
      ref_hdr.update_attributes(:update_flag=>'V')
    }
  }
#  order_cancel.save_transaction(&save_proc)
   if(order_cancel.errors.empty?)
     order_cancel.save_transaction(&save_proc)
   end
  return order_cancel
end

def self.add_or_modify_order_cancel(doc)  
  id =  parse_xml(doc/'id') if (doc/'id').first  
  order_cancel = Sales::SalesOrderCancel.find_or_create(id) 
  return if !order_cancel
  if !order_cancel.new_record? and order_cancel.update_flag == 'V'
    order_cancel.errors.add('This Cancel Order is View Only. Cannot update.') 
    return order_cancel
  end
  order_cancel.apply_attributes(doc) 
  order_cancel.fill_default_header_values() if order_cancel.new_record? 
  order_cancel.max_serial_no = order_cancel.sales_order_cancel_lines.maximum_serial_no
  order_cancel.build_lines(doc/:sales_order_cancel_lines/:sales_order_cancel_line)   
  return order_cancel 
end

private_class_method :create_order_cancel, :add_or_modify_order_cancel

end
