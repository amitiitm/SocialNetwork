class Setup::TypeCrud < Crud
  include General
  
  #  def self.list_types(doc)
  #    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
  #    Setup::Type.find(:all)  
  #  end
  #  
  #  def self.show_type(type_id)
  #    Setup::Type.active.find_all_by_id(type_id)
  #  end
  #  
  #  def self.create_types(doc)
  #    types = [] 
  #    (doc/:types/:type).each{|type_doc|
  #      type = create_type(type_doc)
  #      types <<  type if type
  #    }
  #    types
  #  end
  #
  #  def self.create_type(doc)
  #    type = add_or_modify(doc) 
  #    return  if !type
  #    save_proc = Proc.new{
  #      if type.new_record?
  #        type.save!  
  #      else
  #        type.save! 
  #      end
  #    }
  #    type.save_transaction(&save_proc)
  #    return type
  #  end
  #
  #  def self.add_or_modify(doc)
  #    id =  parse_xml(doc/'id') if (doc/'id').first  
  #    type = Setup::Type.find_or_create(id) 
  #    return if !type
  #    type.apply_attributes(doc) 
  #    return type 
  #  end
  
  #by Amit
  def self.show_app_settings
    #    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
    Setup::Type.active.find(:all,  
      :conditions => ["(
                        (type_cd in ('invn','jewelry_default','metal_type','metal_color','stone_type','stone_shape','stone_shade','stone_cut',
                                     'stone_quality','stone_color','stone_clarity','stone_shape')) OR
                        (type_cd = 'FAAR' and subtype_cd in ('invoice_gl_acct','bank_code','credit_gl_account_cd') ) OR
                        (type_cd = 'FAAP' and subtype_cd in ('credit_gl_account_cd','bank_code') ) OR
                        (type_cd = 'master_access' and subtype_cd = 'vendor' ) OR
                        (type_cd = 'master_access' and subtype_cd = 'customer' ) OR
                        (type_cd='saoi' and subtype_cd in ('equipment_flag','customer_profile','auto_invoiced')) OR
                        (type_cd = 'puoi' and subtype_cd ='other_vends_mem_ord') OR
                        (type_cd = 'workbag' and subtype_cd ='stages') OR
                        (type_cd = 'breakpoint_sales') OR
                        (type_cd = 'prod') OR
                        (type_cd = 'ship') OR
                        (type_cd = 'indigo_file_path') OR
                        (type_cd = 'validate') OR
                        (type_cd = 'artwork_send_proof ') OR
                        (type_cd = 'saoi' and subtype_cd ='other_custs_mem_ord') OR
                        (type_cd = 'aging_customer' and subtype_cd in ('bracket_1_from','bracket_1_to','bracket_2_from','bracket_2_to','bracket_3_from','bracket_3_to','bracket_4_from','bracket_4_to')) OR
                        (type_cd = 'aging_vendor' and subtype_cd in ('bracket_1_from','bracket_1_to','bracket_2_from','bracket_2_to','bracket_3_from','bracket_3_to','bracket_4_from','bracket_4_to')) OR
                        (type_cd = 'aging_inventory' and subtype_cd in ('bracket_1_from','bracket_1_to','bracket_2_from','bracket_2_to','bracket_3_from','bracket_3_to','bracket_4_from','bracket_4_to')) OR
                        (type_cd = 'aging_diamond' and subtype_cd in ('bracket_1_from','bracket_1_to','bracket_2_from','bracket_2_to','bracket_3_from','bracket_3_to','bracket_4_from','bracket_4_to')) OR
                        (type_cd='print_format' and subtype_cd in ('sorder','dpinvoice','dsinvoice','acinvoice','avinvoice','abpayment','ajournal','abdeposit','abtransfer','accreditinvoice',
                                                                   'acreceipt','avcreditinvoice','avwritecheck','dpcreditinvoice','dpmemo','dpmemoreturn','dscreditinvoice','dsmemo',
                                                                   'dsmemoreturn','pcreditinvoice','pmemo','pmemoreturn','pinvoice','sinvoice','screditinvoice','smemo','smemoreturn','porder',
                                                                  'sporder', 'rprorder', 'salesreceipt', 'spowb', 'rprwb', 'cntrmemo') ) )
        "]                                       
    )
  end
  
  def self.create_app_settings(doc)
    types = [] 
    (doc/:types/:type/:details/:detail).each{|type_doc|
      type = create_app_setting(type_doc)
      types <<  type if type
    }
    types
  end

  def self.create_app_setting(doc)
    type = add_or_modify_app_setting(doc) 
    return  if !type
    save_proc = Proc.new{
      if type.new_record?
        type.save!  
      else
        type.save! 
      end
    }
    type.save_transaction(&save_proc)
    return type
  end

  def self.add_or_modify_app_setting(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first  
    type = Setup::Type.find_or_create(id) 
    return if !type
    type.apply_attributes(doc) 
    return type 
  end
  
  def self.list_all_flag
    type = Setup::Type.find(:all, :conditions => "type_cd = 'master_access' AND subtype_cd = 'list_all_flag'", :select => "ISNULL(value, 'Y') AS value")[0]
    if(type)
      return type.value
    else
      return 'Y'
    end
  end
  
end
