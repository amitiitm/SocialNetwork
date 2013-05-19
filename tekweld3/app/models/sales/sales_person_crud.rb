class Sales::SalesPersonCrud
  include General

  def self.list_people(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
    #    Sales::Salesperson.find(:all,
    #      :conditions =>["(code between ? and ? AND (0 =? or code in (?)))AND
    #                        (name between ? and ? AND (0 =? or name in (?))) AND
    #                        ( trans_flag!='D' ) AND
    #                        (category between ? and ? AND (0 =? or category in (?)))
    #        ", 
    #        criteria.str5, criteria.str6,criteria.multiselect5.length, criteria.multiselect5, 
    #        criteria.str3, criteria.str4,criteria.multiselect3.length, criteria.multiselect3,
    #        criteria.str1, criteria.str2,criteria.multiselect1.length, criteria.multiselect1],
    #      :order => "code"
    #    )
    Sales::Salesperson.find(:all,
      :conditions =>["(code between ? and ? AND (0 =? or code in (?)))AND
                        (name between ? and ? AND (0 =? or name in (?))) AND
                        (category between ? and ? AND (0 =? or category in (?)))
        ", 
        criteria.str5, criteria.str6,criteria.multiselect5.length, criteria.multiselect5, 
        criteria.str3, criteria.str4,criteria.multiselect3.length, criteria.multiselect3,
        criteria.str1, criteria.str2,criteria.multiselect1.length, criteria.multiselect1],
      :order => "code"
    )
  end
 
  def self.show_person(people_id)
    Sales::Salesperson.find_all_by_id(people_id)
  end

  def self.create_people(doc)
    people = [] 
    (doc/:sales_peoples/:sales_people).each{|sales_people_doc|
      person = create_person(sales_people_doc)
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
        #        person.salesperson_equipments.save_line
        person.customer_salespeople.save_line
      end
    }
    person.save_transaction(&save_proc)
    return person
  end

  def self.add_or_modify_person(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first
    person = Sales::Salesperson.find_or_create(id) 
    return if !person
    person.apply_attributes(doc) 
    person.fill_default_header_values() if person.new_record? 
    #    person.build_lines(doc/:salesperson_equipments/:salesperson_equipment)
    person.build_lines(doc/:customer_salespeople/:customer_salesperson)
    return person
  end

  private_class_method :create_person, :add_or_modify_person

end

