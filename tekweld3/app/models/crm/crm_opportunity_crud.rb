class Crm::CrmOpportunityCrud
  include General

  def self.list_opportunities(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
    Crm::CrmOpportunity.active.find(:all,
      :joins=>'left outer join crm_accounts on crm_accounts.id = crm_opportunities.crm_account_id',
      :conditions=>["(isnull(account_number,'') between ? and ? AND (0 =? or account_number in (?))) AND
                                   (isnull(crm_opportunities.name,'') between ? and ? AND (0 =? or crm_opportunities.name in (?))) AND
                                   (isnull(crm_opportunities.opportunity_type,'') between ? and ? )   AND
                                    (isnull(crm_opportunities.stage,'')  between ? and ?)  AND
                                    (isnull(crm_opportunities.subject,'')  between ? and ?) 
        ",
        criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
        criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2,
        criteria.str5,criteria.str6,
        criteria.str7,criteria.str8,
        criteria.str9,criteria.str10
      ])                                
  end

  def self.show_opportunities(opportunity_id)
    Crm::CrmOpportunity.find_all_by_id(opportunity_id)
  end

  def self.create_opportunities(doc)
    opportunities = [] 
    (doc/:crm_opportunities/:crm_opportunity).each{|acct_doc|
      opportunity = create_opportunity(acct_doc)
      opportunities <<  opportunity if opportunity
    }
    opportunities
  end

  def self.create_opportunity(doc)
    opportunity = add_or_modify_opportunity(doc) 
    return  if !opportunity
    return opportunity if !opportunity.errors.empty?
    save_proc = Proc.new{
      opportunity.save! 
    }
    opportunity.save_master(&save_proc)
    opportunity
  end

  def self.add_or_modify_opportunity(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first  
    opportunity = Crm::CrmOpportunity.find_or_create(id) 
    return if !opportunity
    return opportunity if opportunity.view_only
    opportunity.apply_attributes(doc)  
    opportunity 
  end

end

