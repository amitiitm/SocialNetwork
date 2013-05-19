class Purchase::PurchasePersonCrud
  include General
  #Purchase People services
  def self.list_people(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = convert_sql_to_db_specific("(purchasepeople.trans_flag = 'A' OR '#{Setup::TypeCrud.list_all_flag}' = 'Y')
                                            AND (nvl(purchasepeople.code,'') between '#{criteria.str1}' and '#{criteria.str2}' AND (0 = #{criteria.multiselect1.length} or purchasepeople.code in ('#{criteria.multiselect1}')))
                                            AND (name between '#{criteria.str3}' and '#{criteria.str4}' AND (0 = #{criteria.multiselect2.length} or name in ('#{criteria.multiselect2}')))")
    Purchase::Purchaseperson.find_by_sql ["select CAST( (select(select purchasepeople.id,
                                                                     purchasepeople.code,
                                                                     purchasepeople.name,
                                                                     purchasepeople.city,
                                                                     purchasepeople.state,
                                                                     purchasepeople.country,
                                                                     purchasepeople.zip,
                                                                     purchasepeople.phone1 
                                                               from purchasepeople
                                                               where #{condition}
                                                               FOR XML PATH('purchase_people'),type,elements xsinil)
                                                               FOR XML PATH('purchase_peoples')) AS xml) as xmlcol 
      "] 
  end

  def self.show_person(people_id)
    Purchase::Purchaseperson.find_all_by_id(people_id)
  end

  def self.create_people(doc)
    people = [] 
    (doc/:purchasepeoples/:purchasepeople).each{|people_doc|
      person = create_person(people_doc)
      people <<  person if person
    }
    people
  end

  def self.create_person(doc)
    person = add_or_modify_person(doc) 
    return  if !person
    save_proc = Proc.new{
      if person.new_record?
        person.save!  
      else
        person.save!     
      end
    }
    #  order.save_transaction(&save_proc)
    if(person.errors.empty?)
      person.save_transaction(&save_proc)
    end
    return person
  end

  def self.add_or_modify_person(doc)  
    id =  parse_xml(doc/'id') if (doc/'id').first  
    person = Purchase::Purchaseperson.find_or_create(id) 
    return if !person
    person.apply_attributes(doc)   
    return person 
  end

  private_class_method :create_person, :add_or_modify_person
  
end
