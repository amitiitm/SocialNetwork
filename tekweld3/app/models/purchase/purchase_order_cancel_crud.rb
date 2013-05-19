class Purchase::PurchaseOrderCancelCrud
  include General

  #Purchase OrderCancel services  
  def self.list_order_cancels(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchaseOrder.find_by_sql ["select CAST( (select(select purchase_order_cancels.id,purchase_order_cancels.trans_bk,purchase_order_cancels.trans_no,
                                    purchase_order_cancels.trans_date,purchase_order_cancels.cancel_date,purchase_order_cancels.account_period_code,
                                    purchase_order_cancels.tracking_no,purchase_order_cancels.ship_date,purchase_order_cancels.item_amt,
                                    purchase_order_cancels.net_amt,vendors.code as vendor_code from purchase_order_cancels
                                    inner join vendors on vendors.id = purchase_order_cancels.vendor_id where
                                    (purchase_order_cancels.trans_flag = 'A') AND
                                    (purchase_order_cancels.company_id = #{ criteria.company_id}) AND
                                    (vendors.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 = #{criteria.multiselect1.length} or vendors.code in ('#{criteria.multiselect1}'))) AND
                                    (trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 = #{criteria.multiselect2.length} or trans_no in ('#{criteria.multiselect2}'))) AND
                                    (trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                                    (account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 = #{criteria.multiselect3.length} or account_period_code in ('#{criteria.multiselect3}')))
                                    order by trans_date, trans_no
                                    FOR XML PATH('purchase_order_cancel'),type,elements xsinil)FOR XML PATH('purchase_order_cancels')) AS xml) as xmlcol "]
  end

  def self.list_open_order_cancels(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchaseOrder.find_by_sql ["select CAST( (select(select b.*, (b.item_qty - b.clear_qty) as open_qty,
                                    catalog_items.taxable as taxable,catalog_items.image_thumnail as image_thumnail, catalog_items.packet_require_yn as packet_require_yn,
                                    purchase_order_cancels.discount_per as hdr_discount_per, 
                                    purchase_order_cancels.discount_amt as hdr_discount_amt, 
                                    purchase_order_cancels.tax_per as hdr_tax_per, 
                                    purchase_order_cancels.tax_amt as hdr_tax_amt,
                                    vendors.code as vendor_code from purchase_order_cancels
                                    inner join vendors on vendors.id = purchase_order_cancels.vendor_id
                                    join purchase_order_cancel_lines b on b.purchase_order_cancel_id = purchase_order_cancels.id 
                                    join catalog_items on catalog_items.id = b.catalog_item_id
                                    where (purchase_order_cancels.trans_flag = 'A') AND
                                    b.purchase_order_cancel_id = purchase_order_cancels.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag = 'A' and
                                    purchase_order_cancels.vendor_id between #{criteria.int1} and #{criteria.int2}
                                    order by purchase_order_cancels.trans_date, purchase_order_cancels.trans_no, b.serial_no
                                    FOR XML PATH('purchase_order_cancel'),type,elements xsinil)FOR XML PATH('purchase_order_cancels')) AS xml) as xmlcol   " ]
  end

  def self.show_order_cancel(order_cancel_id)
    Purchase::PurchaseOrderCancel.find_all_by_id(order_cancel_id)
  end
  
  def self.create_order_cancels(doc)
    order_cancels = [] 
    (doc/:purchase_order_cancels/:purchase_order_cancel).each{|order_cancel_doc|
      order_cancel = create_order_cancel(order_cancel_doc)
      order_cancels <<  order_cancel if order_cancel
    }
    order_cancels
  end

  def self.create_order_cancel(doc)
    order_cancel = add_or_modify_order_cancel(doc) 
    order_cancel.generate_trans_no('PAOIOH') if order_cancel.new_record?
    order_cancel.apply_header_fields_to_lines  
    order_cancel.apply_line_fields_to_header  
    return  if !order_cancel
    ref_hdrs, ref_lines = order_cancel.run_purchase_posting()
    save_proc = Proc.new{
      if order_cancel.new_record?
        order_cancel.save!  
        order_cancel.purchase_order_cancel_lines.each{|line|
          line.transaction_boms.each{|bom|
            line.transaction_bom_id = bom.id
            line.save!
          }
        }
      else
        order_cancel.save! 
        order_cancel.purchase_order_cancel_lines.save_line
        order_cancel.purchase_order_cancel_lines.each{|line|
          line.transaction_boms.save_line
          line.transaction_boms.each{|bom|
            line.transaction_bom_id = bom.id
            line.save!
            bom.transaction_bom_diamonds.save_line
            bom.transaction_bom_stones.save_line
            bom.transaction_bom_others.save_line
            bom.transaction_bom_castings.save_line
            bom.transaction_bom_findings.save_line
          }
        }
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
    order_cancel = Purchase::PurchaseOrderCancel.find_or_create(id) 
    return if !order_cancel
    if !order_cancel.new_record? and order_cancel.update_flag == 'V'
      order_cancel.errors.add('This Cancel Order is View Only. Cannot update.') 
      return order_cancel
    end
    order_cancel.apply_attributes(doc) 
    order_cancel.fill_default_header_values() if order_cancel.new_record? 
    order_cancel.ref_type = order_cancel.trans_type
    order_cancel.max_serial_no = order_cancel.purchase_order_cancel_lines.maximum_serial_no
    order_cancel.build_lines(doc/:purchase_order_cancel_lines/:purchase_order_cancel_line)   
    return order_cancel 
  end

  private_class_method :create_order_cancel, :add_or_modify_order_cancel

end
