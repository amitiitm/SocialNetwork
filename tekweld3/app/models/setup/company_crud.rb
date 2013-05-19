class Setup::CompanyCrud < Crud
  include General
  
  def self.list_companies(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
#    Setup::Company.find(:all,
#      :select => 'companies.*,companies.company_cd as code',
#      :conditions =>[" (company_cd between ? and ? AND (0 =? or company_cd in (?))) AND
#                                          (name between ? and ? AND (0 =? or name in (?))) and trans_flag='A'",
#        criteria.str1,criteria.str2,criteria.multiselect1.length, criteria.multiselect1,
#        criteria.str3, criteria.str4,criteria.multiselect2.length, criteria.multiselect2]  )
    Setup::Company.find(:all,
      :select => 'companies.*,companies.company_cd as code',
      :conditions =>[" (company_cd between ? and ? AND (0 =? or company_cd in (?))) AND
                                          (name between ? and ? AND (0 =? or name in (?)))",
        criteria.str1,criteria.str2,criteria.multiselect1.length, criteria.multiselect1,
        criteria.str3, criteria.str4,criteria.multiselect2.length, criteria.multiselect2]  )
  end

  def self.show_company(company_id)
    Setup::Company.find_all_by_id(company_id)
  end
  
  
  def self.create_companies(doc)
    companies = [] 
    (doc/:companies/:company).each{|company_doc|
      company = create_company(company_doc)
      companies <<  company if company
    }
    companies
  end

  def self.create_company(doc)
    company = add_or_modify(doc) 
    return  if !company
    save_proc = Proc.new{
      if company.new_record?
        company.save! 
        seq=Setup::Sequence.find(:all,
          :conditions=>'company_id=1')
        seq.each{|book|
          seq_new=Setup::Sequence.new
          seq_new=book.clone
          seq_new.company_id = company.id
          seq_new.book_lno=1000
          seq_new.save
        }                     
#        company.sequences.save_line     
      else
        company.save! 
        company.save_user_companies 
        company.sequences.save_line 
#        company.save_sequences
      end
    }
    company.save_transaction(&save_proc)
    return company
  end

  def self.add_or_modify(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first  
    company = Setup::Company.find_or_create(id) 
    return if !company
    company.apply_attributes(doc) 
    #  Add a block to set terms, shippings etc. from code
    company.build_lines(doc/:user_companies/:user_company)
    company.build_lines(doc/:user_books/:sequence)
#    puts company.id
    company.sequences.each{|seq|
     seq.company_id=company.id
    }
    return company 
  end


end
