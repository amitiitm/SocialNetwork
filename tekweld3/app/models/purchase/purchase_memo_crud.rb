class Purchase::PurchaseMemoCrud
  include General

  #Purchase Memo services  
  def self.list_memos(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchaseMemo.find_by_sql ["select CAST( (select(select purchase_memos.id,purchase_memos.trans_bk,purchase_memos.trans_no,purchase_memos.trans_date,
                                    purchase_memos.shipping_code,purchase_memos.account_period_code,purchase_memos.tracking_no,purchase_memos.ship_date,
                                    purchase_memos.item_amt,purchase_memos.net_amt,vendors.code as vendor_code from purchase_memos
                                    inner join vendors on vendors.id = purchase_memos.vendor_id where
                                    (purchase_memos.trans_flag = 'A') AND
                                    (purchase_memos.company_id = #{criteria.company_id}) AND
                                    (vendors.code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 = #{criteria.multiselect1.length} or vendors.code in ('#{criteria.multiselect1}'))) AND
                                    (trans_no between '#{criteria.str3}' and '#{criteria.str4}' AND (0 = #{criteria.multiselect2.length} or trans_no in ('#{criteria.multiselect2}'))) AND
                                    (trans_date between '#{criteria.dt1}' and '#{criteria.dt2}' ) AND
                                    (account_period_code between '#{criteria.str5[0,8]}' and '#{criteria.str6[0,8]}' AND (0 = #{criteria.multiselect3.length} or account_period_code in ('#{criteria.multiselect3}')))
                                    order by trans_date, trans_no
                                    FOR XML PATH('purchase_memo'),type,elements xsinil)FOR XML PATH('purchase_memos')) AS xml) as xmlcol "   ]    
  end

  def self.list_open_memos(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchaseMemo.find_by_sql ["select CAST( (select(select b.*, (b.item_qty - b.clear_qty) as open_qty ,
                                    catalog_items.taxable as taxable, catalog_items.image_thumnail as image_thumnail, catalog_items.packet_require_yn as packet_require_yn,
                                    purchase_memos.discount_per as hdr_discount_per, 
                                    purchase_memos.discount_amt as hdr_discount_amt, 
                                    purchase_memos.tax_per as hdr_tax_per, 
                                    purchase_memos.tax_amt as hdr_tax_amt,vendors.code as vendor_code from purchase_memos
                                    inner join vendors on vendors.id = purchase_memos.vendor_id 
                                    join purchase_memo_lines b on b.purchase_memo_id = purchase_memos.id 
                                    join catalog_items on catalog_items.id = b.catalog_item_id where
                                    (purchase_memos.trans_flag = 'A') AND
                                    b.purchase_memo_id = purchase_memos.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag = 'A' and
                                    ( purchase_memos.company_id = #{criteria.company_id}) and
                                    purchase_memos.vendor_id between #{criteria.int1} and #{criteria.int2}
                                    order by trans_date, trans_no
                                    FOR XML PATH('purchase_memo'),type,elements xsinil)FOR XML PATH('purchase_memos')) AS xml) as xmlcol "  ] 
  end


  def self.list_open_memos_hdr(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchaseMemo.find_by_sql ["select CAST( (select(select distinct purchase_memos.id, purchase_memos.trans_no, purchase_memos.trans_date, purchase_memos.ext_ref_no as vendor_po_no,vendors.code as vendor_code from purchase_memos
                                    inner join vendors on vendors.id = purchase_memos.vendor_id 
                                    join purchase_memo_lines b on b.purchase_memo_id = purchase_memos.id 
                                    join catalog_items on catalog_items.id = b.catalog_item_id where
                                    (purchase_memos.trans_flag = 'A') AND
                                    b.purchase_memo_id = purchase_memos.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag = 'A' and
                                    ( purchase_memos.company_id = #{criteria.company_id}) and
                                    purchase_memos.vendor_id between #{criteria.int1} and #{criteria.int2}
                                    order by trans_date, trans_no
                                    FOR XML PATH('purchase_memo'),type,elements xsinil)FOR XML PATH('purchase_memos')) AS xml) as xmlcol "   ] 
  end

  def self.list_open_memo_lines(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Purchase::PurchaseMemo.find_by_sql ["select CAST( (select(select b.*, (b.item_qty - b.clear_qty) as open_qty ,
                                    catalog_items.taxable as taxable, catalog_items.image_thumnail as image_thumnail, catalog_items.packet_require_yn as packet_require_yn,
                                    purchase_memos.discount_per as hdr_discount_per, 
                                    purchase_memos.discount_amt as hdr_discount_amt, 
                                    purchase_memos.tax_per as hdr_tax_per, 
                                    purchase_memos.tax_amt as hdr_tax_amt,vendors.code as vendor_code from purchase_memos
                                    inner join vendors on vendors.id = purchase_memos.vendor_id 
                                    join purchase_memo_lines b on b.purchase_memo_id = purchase_memos.id 
                                    join catalog_items on catalog_items.id = b.catalog_item_id where
                                    (purchase_memos.trans_flag = 'A') AND
                                    b.purchase_memo_id = purchase_memos.id and
                                    b.item_qty > b.clear_qty and
                                    b.trans_flag = 'A' and
                                    ( purchase_memos.company_id = #{criteria.company_id}) and
                                    purchase_memos.id between #{criteria.int1} and #{criteria.int2}
                                    order by trans_date, trans_no
                                    FOR XML PATH('purchase_memo'),type,elements xsinil)FOR XML PATH('purchase_memos')) AS xml) as xmlcol "   ] 
  end
  
  def self.list_purchase_memo_bom(bom_id)
    select_query = "select transaction_boms.* from transaction_boms where id = #{bom_id} order by trans_date desc"
    query = convert_sql_to_db_specific(select_query)
    TransactionBom::TransactionBom.find_by_sql [query]
  end

  def self.show_memo(memo_id)
    Purchase::PurchaseMemo.find_all_by_id(memo_id)
  end
  
  def self.create_memos_with_log(doc,schema)
    memos = []
    success = 0
    error = 0 
    FileUtils.mkdir_p("#{Dir.getwd}/public/upload_file_logs/#{schema}/")
    directory = "#{Dir.getwd}/public/upload_file_logs/#{schema}/"
    log_filename = "upload_file_log_" + Time.now.strftime('%m-%d-%Y-%H-%M-%S') + ".txt"
    log_file_name = File.join(directory, log_filename)
    File.open(log_file_name,'w+') do |f|
      f.write("Purchase Memo upload starts at #{Time.now.strftime('%m-%d-%Y %H:%M:%S')} . . . \n")
      memos = create_memos(doc)
      memos.each {|memo|
        if memo.errors.empty? 
          f.write("REF no #{memo.ext_ref_no} #{memo.trans_no} uploaded successfully. \n")
          success  = success + 1
        else
          f.write("REF no #{memo.ext_ref_no} has error on uploading. \n")
          error = error + 1
        end   
      }
      f.write("Total #{success + error} record processed.\nsuccess : #{success}\nerror : #{error} \n")
    end
    return memos ,log_filename , error
  end

  
  def self.create_memos(doc)
    memos = [] 
    (doc/:purchase_memos/:purchase_memo).each{|memo_doc|
      memo = create_memo(memo_doc)
      memos <<  memo if memo
    }
    memos
  end

  def self.create_memo(doc)
    memo = add_or_modify_memo(doc) 
    return  if !memo
    memo.generate_trans_no('PAOIMO') if memo.new_record?
    memo.trans_no = parse_xml(doc/"memo_number") if parse_xml(doc/"memo_number")
    memo.apply_header_fields_to_lines  
    memo.apply_line_fields_to_header  
    ref_hdrs, ref_lines = memo.run_purchase_posting()
    #    inventory = Inventory::InventoryPurchase::Posting.new
    #    inventory_postings = inventory.create_inventory_postings(memo)
    save_proc = Proc.new{
      if memo.new_record?
        memo.purchase_memo_lines.each{|line|
          line.catalog_item_batches.each{|batch|
            if batch.types =='PurchaseMemo'
              batch.generate_batch_no('BC01','BATSEQ',memo.trans_type) if batch.new_record?
              line.catalog_item_batches.save_line
              line.catalog_item_batch_code = batch.code
              line.catalog_item_batch_id = batch.id
            end
          }
          line.update_memo_bom if !line.transaction_boms[0]
        }
        memo.save!  
        memo.purchase_memo_lines.each{|line|
          line.transaction_boms.each{|bom|
            line.transaction_bom_id = bom.id
            line.update_memo_bom
            line.save!
          }
        }
      else
        memo.purchase_memo_lines.each{|line|
          line.catalog_item_batches.each{|batch|
            if batch.types =='PurchaseMemo'
              batch.generate_batch_no('BC01','BATSEQ',memo.trans_type) if batch.new_record?
              line.catalog_item_batches.save_line
              line.catalog_item_batch_id = batch.id  if (line.catalog_item_batches and line.catalog_item_batches[0])
              line.catalog_item_batch_code = batch.code  if (line.catalog_item_batches and line.catalog_item_batches[0])
              batch.catalog_item_batch_diamonds.save_line
              batch.catalog_item_batch_stones.save_line
              batch.catalog_item_batch_others.save_line
              batch.catalog_item_batch_castings.save_line
              batch.catalog_item_batch_findings.save_line
            end
          }
          line.transaction_boms.save_line
          line.transaction_boms.each{|bom|
            if( bom.type_id == line.id and bom.types =='PurchaseMemo')
              line.transaction_bom_id = bom.id
              line.transaction_boms.save_line
              bom.transaction_bom_diamonds.save_line
              bom.transaction_bom_stones.save_line
              bom.transaction_bom_others.save_line
              bom.transaction_bom_castings.save_line
              bom.transaction_bom_findings.save_line
            end
          }
        }
        memo.save! 
        memo.purchase_memo_lines.save_line
        memo.purchase_memo_lines.each{|line|
          line.update_memo_bom
        }
      end
      #save reference transactions
      ref_lines.each{|ref_line|
        ref_line.save!
      }if ref_lines
      ref_hdrs.each{|ref_hdr|
        ref_hdr.update_attributes(:update_flag=>'V')
      } if ref_hdrs
      inventory = Inventory::InventoryPurchase::Posting.new
      inventory_postings = inventory.create_inventory_postings(memo)
      Inventory::InventoryPosting.post_inventory_transactions(inventory_postings) if inventory_postings
      #stage detail posting
      inventory_stage = Inventory::InventoryStageSummaryPurchase::StagePosting.new
      inventory_stage_postings = inventory_stage.create_stage_postings(memo)
      Inventory::InventoryStageSummaryPosting.post_inventory_stages(inventory_stage_postings) if inventory_stage_postings
      check_alloc = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','inventory','sales_allocation'])
      memo.run_allocation_posting()  if (check_alloc and check_alloc.value=='Y') #sales allocation posting

    }
    #  memo.save_transaction(&save_proc)
    if(memo.errors.empty?)
      memo.save_transaction(&save_proc)
    end
    return memo
  end

  def self.add_or_modify_memo(doc)  
    id =  parse_xml(doc/'id') if (doc/'id').first  
    memo = Purchase::PurchaseMemo.find_or_create(id) 
    return if !memo
    if !memo.new_record? and memo.update_flag == 'V'
      memo.errors.add('This Memo is View Only. Cannot update.') 
      return memo
    end
    memo.apply_attributes(doc) 
    memo.fill_default_header_values() if memo.new_record? 
    memo.ref_type = memo.trans_type
    memo.max_serial_no = memo.purchase_memo_lines.maximum_serial_no
    memo.build_lines(doc/:purchase_memo_lines/:purchase_memo_line)   
    return memo 
  end

  private_class_method :create_memo, :add_or_modify_memo
end
