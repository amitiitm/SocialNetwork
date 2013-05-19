class Setup::TermCrud < Crud
  include General
  
  def self.list_terms(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    Setup::Term.find(:all,
      :conditions =>[" (code between ? and ? AND (0 =? or code in (?))) AND
                                       (name between ? and ? AND (0 =? or name in (?)))",
        criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
        criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2
      ]) 
   
    Setup::Term.find_by_sql ["select CAST( (select(select terms.id,
                                                          terms.code,
                                                          terms.name,
                                                          terms.pay1_per,
                                                          terms.pay1_days,
                                                          terms.pay2_per,
                                                          terms.pay2_days,
                                                          terms.pay3_per,
                                                          terms.pay3_days,
                                                          terms.pay4_per,
                                                          terms.pay4_days,
                                                          disc_per,
                                                          disc_days,
                                                          terms.trans_flag
                                                  from terms
                                                  where (terms.trans_flag = 'A' OR '#{Setup::TypeCrud.list_all_flag}' = 'Y')
                                                  AND   (code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or code in ('#{criteria.multiselect1}')))
                                                  AND   (name between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or name in ('#{criteria.multiselect2}')))
                                                  FOR XML PATH('term'),type,elements xsinil)
                                                  FOR XML PATH('terms')) AS xml) as xmlcol 
      " ,
      #      criteria.str1,       criteria.str2,      criteria.multiselect1.length,criteria.multiselect1,
      #      criteria.str3,       criteria.str4,      criteria.multiselect2.length,criteria.multiselect2,
    ]                    
  end
  
  def self.show_term(term_id)
    #    Setup::Term.active.find_all_by_id(term_id)
    Setup::Term.find_all_by_id(term_id)
  end
  
  def self.create_terms(doc)
    terms = [] 
    (doc/:terms/:term).each{|term_doc|
      term = create_term(term_doc)
      terms <<  term if term
    }
    terms
  end

  def self.create_term(doc)
    term = add_or_modify(doc) 
    return  if !term
    save_proc = Proc.new{
      if term.new_record?
        term.save!  
      else
        term.save! 
      end
    }
    term.save_transaction(&save_proc)
    return term
  end

  def self.add_or_modify(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first  
    term = Setup::Term.find_or_create(id) 
    return if !term
    term.apply_attributes(doc) 
    return term 
  end
  
end
