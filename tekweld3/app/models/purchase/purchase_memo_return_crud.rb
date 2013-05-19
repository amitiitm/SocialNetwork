class Purchase::PurchaseMemoReturnCrud
  include General

  #Purchase Memo services  
  def self.list_memo_returns(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchaseMemoReturn.find_by_sql ["select CAST( (select(select purchase_memo_returns.id,purchase_memo_returns.trans_bk,purchase_memo_returns.trans_no,
                                    purchase_memo_returns.trans_date,purchase_memo_returns.shipping_code,purchase_memo_returns.account_period_code,
                                    purchase_memo_returns.tracking_no,purchase_memo_returns.ship_date,purchase_memo_returns.item_amt,
                                    purchase_memo_returns.net_amt,vendors.code as vendor_code from purchase_memo_returns
                                    inner join vendors on vendors.id = purchase_memo_returns.vendor_id where
                                    (purchase_memo_returns.trans_flag = 'A') AND
                                    (purchase_memo_returns.company_id = #{criteria.company_id}) AND
                                    (vendors.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 = #{criteria.multiselect1.length} or vendors.code in ('#{criteria.multiselect1}'))) AND
                                    (trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 = #{criteria.multiselect2.length} or trans_no in ('#{criteria.multiselect2}'))) AND
                                    (trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                                    (account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 = #{criteria.multiselect3.length} or account_period_code in ('#{criteria.multiselect3}')))
                                    order by trans_date, trans_no
                                    FOR XML PATH('purchase_memo_return'),type,elements xsinil)FOR XML PATH('purchase_memo_returns')) AS xml) as xmlcol "  ] 
  end

  def self.list_open_memo_returns(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchaseMemoReturn.find_by_sql ["select CAST( (select(select b.*, (b.item_qty - b.clear_qty) as open_qty ,
                                    catalog_items.taxable as taxable, catalog_items.image_thumnail as image_thumnail, catalog_items.packet_require_yn as packet_require_yn,
                                    purchase_memo_returns.discount_per as hdr_discount_per, 
                                    purchase_memo_returns.discount_amt as hdr_discount_amt, 
                                    purchase_memo_returns.tax_per as hdr_tax_per, 
                                    purchase_memo_returns.tax_amt as hdr_tax_amt,vendors.code as vendor_code from purchase_memo_returns
                                    inner join vendors on vendors.id = purchase_memo_returns.vendor_id 
                                    join purchase_memo_return_lines b on b.purchase_memo_return_id = purchase_memo_returns.id 
                                    join catalog_items on catalog_items.id = b.catalog_item_id where
                                    (purchase_memo_returns.trans_flag = 'A') AND
                                    b.purchase_memo_return_id = purchase_memo_returns.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag = 'A' and
                                    purchase_memo_returns.vendor_id between #{criteria.int1} and #{criteria.int2}
                                    order by purchase_memo_returns.trans_date, purchase_memo_returns.trans_no, b.serial_no
                                    FOR XML PATH('purchase_memo_return'),type,elements xsinil)FOR XML PATH('purchase_memo_return')) AS xml) as xmlcol "   ] 
  end

  def self.show_memo_return(memo_return_id)
    Purchase::PurchaseMemoReturn.find_all_by_id(memo_return_id)
  end
  
  def self.create_memo_returns(doc)
    memo_returns = [] 
    (doc/:purchase_memo_returns/:purchase_memo_return).each{|memo_return_doc|
      memo_return = create_memo_return(memo_return_doc)
      memo_returns <<  memo_return if memo_return
    }
    memo_returns
  end

  def self.create_memo_return(doc)
    memo_return = add_or_modify_memo_return(doc) 
    return  if !memo_return
    memo_return.generate_trans_no('PAOIRE') if memo_return.new_record?
    memo_return.apply_header_fields_to_lines  
    memo_return.apply_line_fields_to_header  
    ref_hdrs, ref_lines = memo_return.run_purchase_posting()
    inventory = Inventory::InventoryPurchase::Posting.new
    inventory_postings = inventory.create_inventory_postings(memo_return)
    save_proc = Proc.new{
      if memo_return.new_record?
        memo_return.save!  
        memo_return.purchase_memo_return_lines.each{|line|
          line.transaction_boms.each{|bom|
            line.transaction_bom_id = bom.id
            line.save!
          }
        }
      else
        memo_return.save! 
        memo_return.purchase_memo_return_lines.save_line
        memo_return.purchase_memo_return_lines.each{|line|
          line.transaction_boms.save_line
          line.transaction_boms.each{|bom|
            if( bom.type_id == line.id and bom.types =='PurchaseMemoReturn')
              line.transaction_bom_id = bom.id
              line.save!
              bom.transaction_bom_diamonds.save_line
              bom.transaction_bom_stones.save_line
              bom.transaction_bom_others.save_line
              bom.transaction_bom_castings.save_line
              bom.transaction_bom_findings.save_line
            end
          }
        }
      end
      #save reference transactions
      ref_lines.each{|ref_line|
        ref_line.save!
      }
      ref_hdrs.each{|ref_hdr|
        ref_hdr.update_attributes(:update_flag=>'V')
      } if ref_hdrs
      Inventory::InventoryPosting.post_inventory_transactions(inventory_postings) if inventory_postings
      #stage detail posting
      inventory_stage = Inventory::InventoryStageSummaryPurchase::StagePosting.new
      inventory_stage_postings = inventory_stage.create_stage_postings(memo_return)
      Inventory::InventoryStageSummaryPosting.post_inventory_stages(inventory_stage_postings) if inventory_stage_postings 
      check_alloc = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','inventory','sales_allocation'])
      memo_return.run_allocation_posting()  if (check_alloc and check_alloc.value=='Y') #sales allocation posting
    }
    #  memo_return.save_transaction(&save_proc)
    if(memo_return.errors.empty?)
      memo_return.save_transaction(&save_proc)
    end
    return memo_return
  end

  def self.add_or_modify_memo_return(doc)  
    id =  parse_xml(doc/'id') if (doc/'id').first  
    memo_return = Purchase::PurchaseMemoReturn.find_or_create(id) 
    return if !memo_return
    if !memo_return.new_record? and memo_return.update_flag == 'V'
      memo_return.errors.add('This Memo is View Only. Cannot update.') 
      return memo_return
    end
    memo_return.apply_attributes(doc) 
    memo_return.fill_default_header_values() if memo_return.new_record? 
    memo_return.ref_type = memo_return.trans_type
    memo_return.max_serial_no = memo_return.purchase_memo_return_lines.maximum_serial_no
    memo_return.build_lines(doc/:purchase_memo_return_lines/:purchase_memo_return_line)   
    return memo_return 
  end

  private_class_method :create_memo_return, :add_or_modify_memo_return

end
