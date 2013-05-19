class Crm::CrmLeadCrud
  include General

  def self.list_crm_leads(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
    Crm::CrmLead.active.find(:all,
      :joins=>'inner join crm_account_categories on crm_account_categories.id = crm_leads.crm_lead_category_id',
      :conditions=>["( (lead_number between ? and ? and (0 =? or lead_number in (?)))  AND
                       (crm_account_categories.code between ? and ? and (0 =? or crm_account_categories.code in (?)))  AND
                       (crm_leads.name between ? and ? and (0 =? or crm_leads.name in (?)))  AND
                       (crm_leads.phone between ? and ? and (0 =? or crm_leads.phone in (?)))  AND
                       (isnull(crm_leads.lead_source,'') between  ? and ? ) AND 
                       (isnull(crm_leads.ownership_type,'') between  ? and ? ) AND  
                       (isnull(crm_leads.relationship_type,'')between  ? and ? ) AND  
                       (isnull(crm_leads.industry,'') between  ? and ?) AND
                       (isnull(crm_leads.rating,'') between  ? and ?) AND
                       (isnull(crm_leads.lead_date,'1990-01-01 00:00:00') between  ? and ?)  )
                                    
        ",
        criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1 ,
        criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2,
        criteria.str5,criteria.str6,criteria.multiselect3.length,criteria.multiselect3,
        criteria.str7,criteria.str8,criteria.multiselect4.length,criteria.multiselect4,
        criteria.str9,criteria.str10,
        criteria.str11,criteria.str12,
        criteria.str13,criteria.str14,
        criteria.str15,criteria.str16,
        criteria.str17,criteria.str18,
        criteria.dt1,criteria.dt2
      ],
      :select => "crm_leads.*,crm_account_categories.code as crm_account_category_code")
                                                                
  end

  def self.show_crm_leads(crm_lead_id)
    Crm::CrmLead.find_all_by_id(crm_lead_id)
  end

  def self.create_crm_leads(doc)
    leads = [] 
    (doc/:crm_leads/:crm_lead).each{|lead_doc|
      lead = create_crm_lead(lead_doc)
      leads <<  lead if lead
    }
    leads
  end

  def self.create_crm_lead(doc)
    lead = add_or_modify_crm_lead(doc) 
    return  if !lead
    return lead if !lead.errors.empty?
    save_proc = Proc.new{
      if lead.new_record?
        lead.save!
      else
        lead.save!
        lead.lead_notess.save_line
      end
    }
    lead.save_transaction(&save_proc)
    lead
  end

  def self.add_or_modify_crm_lead(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first  
    lead = Crm::CrmLead.find_or_create(id) 
    return if !lead
    lead.apply_attributes(doc)  
    lead.max_serial_no = lead.lead_notess.maximum_serial_no
    lead.build_lines(doc/:lead_notes/:lead_note) 
    lead 
  end
  
  def self.generate_xml_for_account(doc) 
    xml_string = "<crm_accounts>"
    id = parse_xml(doc/:params/'id')
    crm_leads = Crm::CrmLead.find_all_by_id(id)
    for crm_lead in crm_leads
      xml_string = xml_string+"<crm_account>"
      code =  crm_lead.name.split(" ")[1] ? crm_lead.name.split(" ").first.first + crm_lead.name.split(" ")[1].first : crm_lead.name.split(" ").first.first 
      sequence_no=generate_docu_no('crm','crm',1)
      account_number = code + sequence_no if sequence_no
      Setup::Sequence.upd_book_code('crm','crm',sequence_no,1)
      crm_lead.attributes.each_pair{ |column_name,column_value|
        xml_string = xml_string+"<#{column_name}>#{column_value}</#{column_name}>" if column_name!='id' and column_name!='account_period_code' and column_name!='account_number'
      }
      xml_string = xml_string +"<id></id>"
      xml_string = xml_string +"<account_number>#{account_number}</account_number>"
      xml_string = xml_string +"<crm_account_category_id>#{crm_lead.crm_lead_category_id}</crm_account_category_id>"
      xml_string = xml_string +"<account_period_code>#{Setup::AccountPeriod.period_from_date(Time.now).code}</account_period_code>"
      xml_string = xml_string+"</crm_account>"
    end   
    xml_string = xml_string+"</crm_accounts>"
    xml = %{#{xml_string}}
    acc_doc = Hpricot::XML(xml)
    return acc_doc 
  end
  
  def self.create_account_from_lead(account_doc,id)
    crm_lead = Crm::CrmLead.find_by_id(id)
    accounts=[]
    save_proc = Proc.new{
      accounts=Crm::CrmAccountCrud.create_accounts(account_doc)
      account =  accounts.first if !accounts.empty?
      crm_lead.update_attributes(:account_id=>account.id,:account_number=>account.account_number) if crm_lead
    }
    crm_lead.save_transaction(&save_proc) if crm_lead
    accounts
  end
  
  
  def self.generate_docu_no(book_code,docu_typ,company_id)
    begin
      if lno = Setup::Sequence.maximum(:book_lno, :conditions =>[ "book_cd =? and docu_typ = ? and company_id =? and trans_flag = 'A'",book_code, docu_typ,company_id])     
        lno =lno.to_i + 1
      end 
    rescue ActiveRecord::RecordNotFound  
      lno = nil
    end      
    lno.to_s
  end

  def self.upd_book_code(book_code,docu_typ,trans_no,company_id)
    begin
      seq = Setup::Sequence.find_by_book_cd_and_docu_typ_and_company_id_and_trans_flag(book_code, docu_typ,company_id, 'A')  
      book_lno = seq ? seq.book_lno : 0
      lno = (book_lno.to_i >=  trans_no.to_i) ? book_lno.to_i + 1  : trans_no
      #      lno = (seq.book_lno).to_i + 1    
      #      lno = lno.to_s
      seq.update_attributes(:book_lno=>lno.to_s)  if seq
      #   end
    rescue ActiveRecord::RecordNotFound  
      lno = nil
    end  
  end
  private_class_method :create_crm_lead, :add_or_modify_crm_lead
end
