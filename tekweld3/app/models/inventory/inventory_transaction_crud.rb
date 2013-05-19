class Inventory::InventoryTransactionCrud
  include General

  #Inventory Transaction services  
  def self.list_issue_transactions(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
    condition = " (company_id=?) AND
                                    (trans_bk  = 'IS01') AND (receipt_issue_flag='I') AND
                                    (trans_no between ? and ? AND (0 =? or trans_no in (?))) AND
                                    (trans_date between ? and ? ) AND
                                    (account_period_code between ? and ? AND (0 =? or account_period_code in (?))) AND
                                    (nvl(ext_ref_no,'') between ? and ? AND (0 =? or ext_ref_no in (?)))
    " 
    condition = convert_sql_to_db_specific(condition)
#    Inventory::InventoryTransaction.active.find(:all,
#      :conditions => [condition,criteria.company_id,criteria.str1,     criteria.str2,     criteria.multiselect1.length, criteria.multiselect1,
#        criteria.dt1,      criteria.dt2,
#        criteria.str3[0,8],criteria.str4[0,8],criteria.multiselect2.length, criteria.multiselect2, 
#        criteria.str5,     criteria.str6,     criteria.multiselect3.length, criteria.multiselect3],
#      :order => "trans_date, trans_no"
#    )
    Inventory::InventoryTransaction.find_by_sql ["select CAST( (select(select inventory_transactions.id,inventory_transactions.trans_bk,inventory_transactions.trans_no,
                                          inventory_transactions.trans_date,inventory_transactions.account_period_code,inventory_transactions.trans_type,
                                          inventory_transactions.trans_type_id,inventory_transactions.ext_ref_no,inventory_transactions.remarks from inventory_transactions
                                          where inventory_transactions.trans_flag = 'A' AND
                                          #{condition}
                                          order by inventory_transactions.trans_date, inventory_transactions.trans_no 
                                          FOR XML PATH('inventory_transaction'),type,elements xsinil)FOR XML PATH('inventory_transactions')) AS xml) as XMLCOL ",
                                          criteria.company_id,criteria.str1,     criteria.str2,     criteria.multiselect1.length, criteria.multiselect1,
                                          criteria.dt1,      criteria.dt2,
                                          criteria.str3[0,8],criteria.str4[0,8],criteria.multiselect2.length, criteria.multiselect2, 
                                          criteria.str5,     criteria.str6,     criteria.multiselect3.length, criteria.multiselect3
                                ] 
  end

  def self.list_receive_transactions(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
    condition = "(company_id = ?) AND
                                    (trans_bk  = 'RE01') AND (receipt_issue_flag='R') AND
                                    (trans_no between ? and ? AND (0 =? or trans_no in (?))) AND
                                    (trans_date between ? and ? ) AND
                                    (account_period_code between ? and ? AND (0 =? or account_period_code in (?))) AND
                                    (nvl(ext_ref_no,'') between ? and ? AND (0 =? or ext_ref_no in (?)))
    "
    condition = convert_sql_to_db_specific(condition)
#    Inventory::InventoryTransaction.active.find(:all,
#      :conditions => [condition ,criteria.company_id,criteria.str1,     criteria.str2,     criteria.multiselect1.length, criteria.multiselect1,
#        criteria.dt1,      criteria.dt2,
#        criteria.str3[0,8],criteria.str4[0,8],criteria.multiselect2.length, criteria.multiselect2, 
#        criteria.str5,     criteria.str6,     criteria.multiselect3.length, criteria.multiselect3],
#      :order => "trans_date, trans_no"
#    )
    Inventory::InventoryTransaction.find_by_sql ["select CAST( (select(select inventory_transactions.id,inventory_transactions.trans_bk,inventory_transactions.trans_no,
                                          inventory_transactions.trans_date,inventory_transactions.account_period_code,inventory_transactions.trans_type,
                                          inventory_transactions.trans_type_id,inventory_transactions.ext_ref_no,inventory_transactions.remarks from inventory_transactions
                                          where inventory_transactions.trans_flag = 'A' AND
                                          #{condition}
                                          order by inventory_transactions.trans_date, inventory_transactions.trans_no 
                                          FOR XML PATH('inventory_transaction'),type,elements xsinil)FOR XML PATH('inventory_transactions')) AS xml) as XMLCOL ",
                                          criteria.company_id,criteria.str1,     criteria.str2,     criteria.multiselect1.length, criteria.multiselect1,
                                          criteria.dt1,      criteria.dt2,
                                          criteria.str3[0,8],criteria.str4[0,8],criteria.multiselect2.length, criteria.multiselect2, 
                                          criteria.str5,     criteria.str6,     criteria.multiselect3.length, criteria.multiselect3
                                ]
  end

  def self.list_transfer_transactions(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
    #  condition = "(company_id = ?) AND
    #                                    (trans_bk  = 'TR01') AND (receipt_issue_flag='T') AND
    #                                    (trans_no between ? and ? AND (0 =? or trans_no in (?))) AND
    #                                    (trans_date between ? and ? ) AND
    #                                    (account_period_code between ? and ? AND (0 =? or account_period_code in (?))) AND
    #                                    (nvl(ext_ref_no,'') between ? and ? AND (0 =? or ext_ref_no in (?)))
    #                                    "
    condition = "(company_id = ?) AND
                                  ( trans_type = 'T' ) AND
                                    (trans_no between ? and ? AND (0 =? or trans_no in (?))) AND
                                    (trans_date between ? and ? ) AND
                                    (account_period_code between ? and ? AND (0 =? or account_period_code in (?))) AND
                                    (nvl(ext_ref_no,'') between ? and ? AND (0 =? or ext_ref_no in (?)))
    "
    condition = convert_sql_to_db_specific(condition)
#    Inventory::InventoryTransaction.active.find(:all,
#      :conditions => [condition ,criteria.company_id,criteria.str1,     criteria.str2,     criteria.multiselect1.length, criteria.multiselect1,
#        criteria.dt1,      criteria.dt2,
#        criteria.str3[0,8],criteria.str4[0,8],criteria.multiselect2.length, criteria.multiselect2, 
#        criteria.str5,     criteria.str6,     criteria.multiselect3.length, criteria.multiselect3],
#      :order => "trans_date, trans_no"
#    )
    Inventory::InventoryTransaction.find_by_sql ["select CAST( (select(select inventory_transactions.id,inventory_transactions.trans_bk,inventory_transactions.trans_no,
                                          inventory_transactions.trans_date,inventory_transactions.account_period_code,inventory_transactions.trans_type,
                                          inventory_transactions.trans_type_id,inventory_transactions.ext_ref_no,inventory_transactions.remarks from inventory_transactions
                                          where inventory_transactions.trans_flag = 'A' AND
                                          #{condition}
                                          order by inventory_transactions.trans_date, inventory_transactions.trans_no 
                                          FOR XML PATH('inventory_transaction'),type,elements xsinil)FOR XML PATH('inventory_transactions')) AS xml) as XMLCOL ",
                                          criteria.company_id,criteria.str1,     criteria.str2,     criteria.multiselect1.length, criteria.multiselect1,
                                          criteria.dt1,      criteria.dt2,
                                          criteria.str3[0,8],criteria.str4[0,8],criteria.multiselect2.length, criteria.multiselect2, 
                                          criteria.str5,     criteria.str6,     criteria.multiselect3.length, criteria.multiselect3
                                ]
  end

  def self.show_inventory_transaction(inventory_transaction_id)
    Inventory::InventoryTransaction.find_all_by_id(inventory_transaction_id)
  end
  
  def self.create_inventory_transactions(doc)
    inventory_transactions = [] 
    (doc/:inventory_transactions/:inventory_transaction).each{|transaction_doc|
      inventory_transaction = create_inventory_transaction(transaction_doc)
      inventory_transactions <<  inventory_transaction if inventory_transaction
    }
    inventory_transactions
  end

  def self.create_inventory_transaction(doc)
    inventory_transaction = add_or_modify_inventory_transaction(doc) 
    return  if !inventory_transaction
    case inventory_transaction.receipt_issue_flag 
    when 'I'
      inventory_transaction.trans_bk='IS01'
      inventory_transaction.generate_trans_no('INVNIS') if inventory_transaction.new_record?
    when 'R'
      inventory_transaction.trans_bk='RE01'
      inventory_transaction.generate_trans_no('INVNRE') if inventory_transaction.new_record?
    when 'T'
      inventory_transaction.trans_bk='TR01'
      inventory_transaction.generate_trans_no('INVNTR') if inventory_transaction.new_record?
    end
    inventory_transaction.apply_header_fields_to_lines  
    inventory_transaction.apply_line_fields_to_header  
    inventory = Inventory::InventoryTrans::Posting.new
    inventory_postings = inventory.create_inventory_postings(inventory_transaction)
    save_proc = Proc.new{
      if inventory_transaction.new_record?
        inventory_transaction.save!  
      else
        inventory_transaction.save! 
        inventory_transaction.inventory_transaction_lines.save_line
      end
      Inventory::InventoryPosting.post_inventory_transactions(inventory_postings) if inventory_postings
      if inventory_transaction.receipt_issue_flag == 'I' and inventory_transaction.trans_type == 'S'
        Inventory::InventoryTransferCrud.post_inventory_transfers(inventory_transaction.trans_date,
          inventory_transaction.company_id,
          inventory_transaction.trans_type_id,
          inventory_postings) if inventory_postings
        email = Email::Email.send_email('Store Transfer Issue',inventory_transaction)
        email.save_this_mail  if email
      end
    }
    inventory_transaction.save_transaction(&save_proc)
    return inventory_transaction
  end

  def self.add_or_modify_inventory_transaction(doc)  
    id =  parse_xml(doc/'id') if (doc/'id').first  
    inventory_transaction = Inventory::InventoryTransaction.find_or_create(id) 
    return if !inventory_transaction
    if !inventory_transaction.new_record? and inventory_transaction.update_flag == 'V'
      inventory_transaction.errors.add('','This transaction is View Only. Cannot update.') 
      return inventory_transaction
    end
    inventory_transaction.apply_attributes(doc) 
    inventory_transaction.fill_default_header_values() if inventory_transaction.new_record?
    inventory_transaction.max_serial_no = inventory_transaction.inventory_transaction_lines.maximum_serial_no
    inventory_transaction.build_lines(doc/:inventory_transaction_lines/:inventory_transaction_line)   
    inventory_transaction.build_lines(doc/:inventory_transaction_issue_lines/:inventory_transaction_issue_line) 
    inventory_transaction.build_lines(doc/:inventory_transaction_receive_lines/:inventory_transaction_receive_line)   
    return inventory_transaction 
  end

  def self.post_receive_transaction(inventory_transfers)
    inventory_transaction = add_inventory_receive_transaction(inventory_transfers) 
    return  if !inventory_transaction
    inventory_transaction.trans_bk='RE01'
    inventory_transaction.generate_trans_no('INVNRE') if inventory_transaction.new_record?
    inventory_transaction.apply_header_fields_to_lines  
    inventory_transaction.apply_line_fields_to_header  
    inventory = Inventory::InventoryTrans::Posting.new
    inventory_postings = inventory.create_inventory_postings(inventory_transaction)
    save_proc = Proc.new{
      if inventory_transaction.new_record?
        inventory_transaction.save!  
      else
        inventory_transaction.save! 
        inventory_transaction.inventory_transaction_lines.save_line
      end
      Inventory::InventoryPosting.post_inventory_transactions(inventory_postings) if inventory_postings
    }
    inventory_transaction.save_transaction(&save_proc)
    email = Email::Email.send_email('Store Transfer Receive',inventory_transaction)
    email.save_this_mail  if email
    return inventory_transaction
  end

  def self.add_inventory_receive_transaction(inventory_transfers)  
    inventory_transaction = Inventory::InventoryTransaction.new
    return if !inventory_transaction
    #inventory_transaction.apply_attributes(doc) 
    inventory_transaction.trans_date = inventory_transfers.first.received_trans_date
    inventory_transaction.account_period_code = inventory_transfers.first.account_period_code
    inventory_transaction.company_id = inventory_transfers.first.company_id
    inventory_transaction.receipt_issue_flag = 'R'
    inventory_transaction.trans_type = 'S'
    inventory_transaction.trans_type_id = inventory_transfers.first.store_id_from
    inventory_transaction.ext_ref_no = ''
    inventory_transaction.fill_default_header_values() if inventory_transaction.new_record?
    inventory_transaction.max_serial_no = inventory_transaction.inventory_transaction_lines.maximum_serial_no
    #add lines
    inventory_transfers.each {|inventory_transfer|
      #inventory_transfer_line = Inventory::InventoryTransactionLine.new
      #inventory_transaction_line = inventory_transaction.inventory_transaction_lines.find_or_build(0)
      inventory_transaction_line = inventory_transaction.add_receive_line_details('')
      inventory_transaction_line.company_id = inventory_transfer.company_id
      inventory_transaction_line.receipt_issue_flag = 'R'
      inventory_transaction_line.catalog_item_id = inventory_transfer.catalog_item_id
      inventory_transaction_line.catalog_item_code = inventory_transfer.catalog_item_code
      inventory_transaction_line.catalog_item_packet_id = inventory_transfer.catalog_item_packet_id
      inventory_transaction_line.catalog_item_packet_code = inventory_transfer.catalog_item_packet_code
      inventory_transaction_line.rec_qty = inventory_transfer.transfer_qty
      inventory_transaction_line.rec_price = inventory_transfer.transfer_price
      inventory_transaction_line.rec_amt = inventory_transfer.transfer_amt
      inventory_transaction_line.fill_default_detail_values
      inventory_transaction.max_serial_no = inventory_transaction_line.serial_no = (inventory_transaction.max_serial_no.to_i + 1).to_s
    }
    return inventory_transaction 
  end


  def self.list_inventory_packet_assignments(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
    condition = " (company_id=?) AND
                                    (trans_bk  = 'TR05') AND
                                    (trans_no between ? and ? AND (0 =? or trans_no in (?))) AND
                                    (trans_date between ? and ? ) AND
                                    (account_period_code between ? and ? AND (0 =? or account_period_code in (?))) AND
                                    (nvl(ext_ref_no,'') between ? and ? AND (0 =? or ext_ref_no in (?)))
    "
    condition = convert_sql_to_db_specific(condition)
#    Inventory::InventoryTransaction.active.find(:all,
#      :conditions => [condition ,criteria.company_id,criteria.str1,     criteria.str2,     criteria.multiselect1.length, criteria.multiselect1,
#        criteria.dt1,      criteria.dt2,
#        criteria.str3[0,8],criteria.str4[0,8],criteria.multiselect2.length, criteria.multiselect2, 
#        criteria.str5,     criteria.str6,     criteria.multiselect3.length, criteria.multiselect3],
#      :order => "trans_date, trans_no"
#    )
    Inventory::InventoryTransaction.find_by_sql ["select CAST( (select(select inventory_transactions.id,inventory_transactions.trans_bk,inventory_transactions.trans_no,
                                          inventory_transactions.trans_date,inventory_transactions.account_period_code,inventory_transactions.trans_type,
                                          inventory_transactions.trans_type_id,inventory_transactions.ext_ref_no,inventory_transactions.remarks from inventory_transactions
                                          where inventory_transactions.trans_flag = 'A' AND
                                          #{condition}
                                          order by inventory_transactions.trans_date, inventory_transactions.trans_no 
                                          FOR XML PATH('inventory_transaction'),type,elements xsinil)FOR XML PATH('inventory_transactions')) AS xml) as XMLCOL ",
                                          criteria.company_id,criteria.str1,     criteria.str2,     criteria.multiselect1.length, criteria.multiselect1,
                                          criteria.dt1,      criteria.dt2,
                                          criteria.str3[0,8],criteria.str4[0,8],criteria.multiselect2.length, criteria.multiselect2, 
                                          criteria.str5,     criteria.str6,     criteria.multiselect3.length, criteria.multiselect3
                                ]
  end

  def self.show_inventory_packet_assignment(inventory_transaction_id)
    Inventory::InventoryTransaction.find_all_by_id(inventory_transaction_id)
  end

  def self.create_inventory_packet_assignments(doc)
    inventory_transactions = [] 
    (doc/:inventory_transactions/:inventory_transaction).each{|transaction_doc|
      inventory_transaction = create_inventory_packet_assignment(transaction_doc)
      inventory_transactions <<  inventory_transaction if inventory_transaction
    }
    inventory_transactions
  end

  def self.create_inventory_packet_assignment(doc)
    inventory_transaction = add_or_modify_inventory_packet_assignment(doc) 
    return  if !inventory_transaction
    return inventory_transaction  if !inventory_transaction.errors.empty?
    case inventory_transaction.receipt_issue_flag 
    when 'I'
      inventory_transaction.trans_bk='IS01'
      inventory_transaction.generate_trans_no('INVNIS') if inventory_transaction.new_record?
    when 'R'
      inventory_transaction.trans_bk='RE01'
      inventory_transaction.generate_trans_no('INVNRE') if inventory_transaction.new_record?
    when 'T'
      case inventory_transaction.trans_type
      when 'P'
        inventory_transaction.trans_bk='TR05'
        inventory_transaction.generate_trans_no('INVNTR') if inventory_transaction.new_record?
      else
        inventory_transaction.trans_bk='TR01'
        inventory_transaction.generate_trans_no('INVNTR') if inventory_transaction.new_record?
      end
    end
    inventory_transaction.apply_header_fields_to_lines  
    inventory_transaction.apply_line_fields_to_header  
    inventory = Inventory::InventoryTrans::Posting.new
    inventory_postings = inventory.create_inventory_postings(inventory_transaction)
    save_proc = Proc.new{
      if inventory_transaction.new_record?
        inventory_transaction.save!  
      else
        inventory_transaction.save! 
        inventory_transaction.inventory_transaction_lines.save_line
      end
      Inventory::InventoryPosting.post_inventory_transactions(inventory_postings) if inventory_postings
      if inventory_transaction.receipt_issue_flag == 'I' and inventory_transaction.trans_type == 'S'
        Inventory::InventoryTransferCrud.post_inventory_transfers(inventory_transaction.trans_date,
          inventory_transaction.company_id,
          inventory_transaction.trans_type_id,
          inventory_postings) if inventory_postings
      end
    }
    inventory_transaction.save_transaction(&save_proc)
    return inventory_transaction
  end

  #def self.add_or_modify_inventory_packet_assignment(doc)  
  #  id =  parse_xml(doc/'id') if (doc/'id').first  
  #  inventory_transaction = Inventory::InventoryTransaction.find_or_create(id) 
  #  return if !inventory_transaction
  #  if !inventory_transaction.new_record? and inventory_transaction.update_flag == 'V'
  #    inventory_transaction.errors.add('','This transaction is View Only. Cannot update.') 
  #    return inventory_transaction
  #  end
  #  inventory_transaction.apply_attributes(doc) 
  #  inventory_transaction.fill_default_header_values() if inventory_transaction.new_record?
  #  inventory_transaction.max_serial_no = inventory_transaction.inventory_transaction_lines.maximum_serial_no
  #  inventory_transaction.update_flag = 'V'
  #  inventory_transaction.build_lines(doc/:inventory_transaction_issue_lines/:inventory_transaction_issue_line) 
  #  item_packets = Item::CatalogItemPacketCrud.create_catalog_item_assigned_packets(doc/:inventory_transaction_receive_lines/:inventory_transaction_receive_line,inventory_transaction.company_id)
  #  inventory_transaction.build_lines(doc/:inventory_transaction_receive_lines/:inventory_transaction_receive_line)   
  #  item_packet_index = 0
  #  inventory_transaction.inventory_transaction_lines.each{|line|
  #    if line.receipt_issue_flag == 'R'
  ##      catalog_item_packet_id = Item::CatalogItemPacket.find_by_code(line.catalog_item_packet_code).id if line.catalog_item_packet_code
  #      line.catalog_item_packet_id = item_packets[item_packet_index].id
  #      line.catalog_item_packet_code = item_packets[item_packet_index].code
  #       if !line.catalog_item_packet_id
  #      inventory_transaction.errors.add(item_packets[item_packet_index].errors.each{|err,msg| 
  #                 msg }) 
  #       end
  #      item_packet_index += 1
  #       end
  #      line.update_flag = 'V'
  #  }
  #  return inventory_transaction 
  #end
  def self.add_or_modify_inventory_packet_assignment(doc)  
    id =  parse_xml(doc/'id') if (doc/'id').first  
    inventory_transaction = Inventory::InventoryTransaction.find_or_create(id) 
    return if !inventory_transaction
    if !inventory_transaction.new_record? and inventory_transaction.update_flag == 'V'
      inventory_transaction.errors.add('','This transaction is View Only. Cannot update.') 
      return inventory_transaction
    end
    inventory_transaction.apply_attributes(doc) 
    inventory_transaction.fill_default_header_values() if inventory_transaction.new_record?
    inventory_transaction.max_serial_no = inventory_transaction.inventory_transaction_lines.maximum_serial_no
    inventory_transaction.update_flag = 'V'
    inventory_transaction.build_lines(doc/:inventory_transaction_issue_lines/:inventory_transaction_issue_line) 
    item_packets = Item::CatalogItemPacketCrud.create_catalog_item_assigned_packets(doc/:inventory_transaction_receive_lines/:inventory_transaction_receive_line,inventory_transaction.company_id)
    inventory_transaction.build_lines(doc/:inventory_transaction_receive_lines/:inventory_transaction_receive_line)   
    item_packet_index = 0
    inventory_transaction.inventory_transaction_lines.each{|line|
      if line.receipt_issue_flag == 'R'
        #      catalog_item_packet_id = Item::CatalogItemPacket.find_by_code(line.catalog_item_packet_code).id if line.catalog_item_packet_code
        line.catalog_item_packet_id = item_packets[item_packet_index].id
        line.catalog_item_packet_code = item_packets[item_packet_index].code
        if !(line.catalog_item_packet_id)
          inventory_transaction.errors.add(item_packets[item_packet_index].errors.each{|err,msg|
              msg }) 
        end
        item_packet_index += 1
      end
      line.update_flag = 'V'
    }
    return inventory_transaction 
  end

  private_class_method :create_inventory_transaction, :add_or_modify_inventory_transaction

end
