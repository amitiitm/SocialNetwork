class Inventory::LaborCrud
  include General
  def self.list_labors(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
#    Inventory::Labor.active.find(:all,
#      :joins => "",
#      :conditions => ["(labors.company_id = ?) AND
#                       (code between ? and ? AND (0 =? or code in (?))) AND
#                       (labor_type between ? and ? AND (0 =? or labor_type in (?)))
#        ",criteria.company_id,
#        criteria.str1,criteria.str2,criteria.multiselect1.length, criteria.multiselect1, 
#        criteria.str3,criteria.str4,criteria.multiselect2.length, criteria.multiselect2
#      ],
#      :order => "code"
#    )
#    Inventory::Labor.find(:all,
#      :conditions => ["(labors.company_id = ?) AND
#                       (code between ? and ? AND (0 =? or code in (?))) AND
#                       (labor_type between ? and ? AND (0 =? or labor_type in (?)))
#        ",criteria.company_id,
#        criteria.str1,criteria.str2,criteria.multiselect1.length, criteria.multiselect1, 
#        criteria.str3,criteria.str4,criteria.multiselect2.length, criteria.multiselect2
#      ],
#      :order => "code"
#    )
    Inventory::Labor.find_by_sql ["select CAST( (select(select labors.id,labors.code,labors.description,labors.qty,
                                  labors.price,labors.cost,labors.trans_flag from labors
                                  where (labors.company_id = ?) AND
                                  (code between ? and ? AND (0 =? or code in (?))) AND
                                  (labor_type between ? and ? AND (0 =? or labor_type in (?)))
                                  order by code
                                  FOR XML PATH('labor'),type,elements xsinil)FOR XML PATH('labors')) AS xml) as XMLCOL ",
                                  criteria.company_id,
                                  criteria.str1,criteria.str2,criteria.multiselect1.length, criteria.multiselect1, 
                                  criteria.str3,criteria.str4,criteria.multiselect2.length, criteria.multiselect2
                                ]
  end
  
  def self.show_labor(labor_id)
    Inventory::Labor.find_all_by_id(labor_id)
  end
  

  def self.create_labors(doc)
    labors = [] 
    (doc/:labors/:labor).each{|pos_order_doc|
      labor = create_labor(pos_order_doc)
      labors <<  labor if labor
    }
    labors
  end
  
  def self.create_labor(doc)
    labor = add_or_modify_labor(doc)  
    return  if !labor
    save_proc = Proc.new{
      if labor.new_record?
        labor.save!  
      else
        labor.save! 
      end
    }
    if(labor.errors.empty?)
      labor.save_transaction(&save_proc)
    end
    return labor
  end

  def self.add_or_modify_labor(doc)  
    id =  parse_xml(doc/'id') if (doc/'id').first  
    labor = Inventory::Labor.find_or_create(id) 
    return if !labor
    labor.apply_attributes(doc) 
    labor.fill_default_header_values() if labor.new_record? 
    return labor 
  end

  private_class_method :create_labor, :add_or_modify_labor

end