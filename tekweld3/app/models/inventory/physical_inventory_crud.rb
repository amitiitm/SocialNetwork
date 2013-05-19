class Inventory::PhysicalInventoryCrud
include General

def self.list_physical_inventories(doc)
  criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
#  Inventory::PhysicalInventory.active.find(:all,
#                    :joins => "",
#                    :conditions => ["(physical_inventories.company_id = ?) AND
#                                    (trans_no between ? and ? AND (0 =? or trans_no in (?))) AND
#                                    (trans_date between ? and ? ) AND
#                                    (account_period_code between ? and ? AND (0 =? or account_period_code in (?)))
#                                    ",criteria.company_id,
#                                     criteria.str1,criteria.str2,criteria.multiselect1.length, criteria.multiselect1, 
#                                     criteria.dt1, criteria.dt2,
#                                     criteria.str3[0,8], criteria.str4[0,8],criteria.multiselect2.length, criteria.multiselect2],
#                    :order => "trans_date, trans_no"
#  )
  Inventory::PhysicalInventory.find_by_sql ["select CAST( (select(select physical_inventories.id,physical_inventories.trans_bk,physical_inventories.trans_no,
                                          physical_inventories.trans_date,physical_inventories.account_period_code from physical_inventories
                                          where physical_inventories.trans_flag = 'A' AND
                                          (physical_inventories.company_id = ?) AND
                                          (trans_no between ? and ? AND (0 =? or trans_no in (?))) AND
                                          (trans_date between ? and ? ) AND
                                          (account_period_code between ? and ? AND (0 =? or account_period_code in (?)))
                                          order by physical_inventories.trans_date, physical_inventories.trans_no 
                                          FOR XML PATH('inventory_transaction'),type,elements xsinil)FOR XML PATH('physical_inventories')) AS xml) as XMLCOL ",
                                          criteria.company_id,
                                          criteria.str1,criteria.str2,criteria.multiselect1.length, criteria.multiselect1, 
                                          criteria.dt1, criteria.dt2,
                                          criteria.str3[0,8], criteria.str4[0,8],criteria.multiselect2.length, criteria.multiselect2
                                ]
end
  
def self.show_physical_inventory(physical_invn_id)
  Inventory::PhysicalInventory.find_all_by_id(physical_invn_id)
end
  
def self.create_physical_inventories(doc)
  phys_invns = [] 
  (doc/:physical_inventories/:physical_inventory).each{|invn_doc|
  phys_invn = create_physical_inventory(invn_doc)
  phys_invns <<  phys_invn if phys_invn
  }
  phys_invns
end

def self.create_physical_inventory(doc)
  phys_invn = add_or_modify_physical_inventory(doc) 
  phys_invn.generate_trans_no('INVNPH') if phys_invn.new_record?
  phys_invn.apply_header_fields_to_lines  
#  order.apply_line_fields_to_header  
  return  if !phys_invn
  save_proc = Proc.new{
    if phys_invn.new_record?
      phys_invn.save!  
    else
      phys_invn.save! 
      phys_invn.physical_inventory_lines.save_line
    end
  }
  phys_invn.save_transaction(&save_proc)
  return phys_invn
end

def self.add_or_modify_physical_inventory(doc)  
  id =  parse_xml(doc/'id') if (doc/'id').first  
  phys_invn = Inventory::PhysicalInventory.find_or_create(id) 
  return if !phys_invn
  phys_invn.apply_attributes(doc) 
  phys_invn.fill_default_header_values() if phys_invn.new_record? 
  phys_invn.max_serial_no = phys_invn.physical_inventory_lines.maximum_serial_no
  phys_invn.build_lines(doc/:physical_inventory_lines/:physical_inventory_line)   
  return phys_invn 
end

private_class_method :create_physical_inventory, :add_or_modify_physical_inventory

end
