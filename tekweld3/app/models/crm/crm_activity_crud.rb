class Crm::CrmActivityCrud
  include General


  def self.list_activities(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
    Crm::CrmActivity.active.find(:all,
      :joins => "left outer join crm_accounts on crm_accounts.id = crm_activities.crm_account_id
                 left outer join crm_contacts on crm_contacts.id = crm_activities.crm_contact_id
                 left outer join users on users.id = crm_activities.performed_user_id",
      :conditions=>[" crm_activities.trans_date between ? and ? And
                     (isnull(crm_activities.subject,'') between ? and ? and (0 =? or crm_activities.subject in (?))) AND 
                     (isnull(crm_accounts.account_number,'') between ? and ? and (0 =? or crm_accounts.account_number in (?))) AND
                     (isnull(crm_contacts.first_name,'') between ? and ? and (0 =? or crm_contacts.first_name in (?))) AND
                     (isnull(users.first_name,'') between ? and ? and (0 =? or users.first_name in (?))) AND
                     (crm_activities.trans_no between ? and ? and (0 =? or crm_activities.trans_no in (?)))
        ",
        criteria.dt1,criteria.dt2,
        criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
        criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2,
        criteria.str5,criteria.str6,criteria.multiselect3.length,criteria.multiselect3,
        criteria.str7,criteria.str8,criteria.multiselect4.length,criteria.multiselect4,
        criteria.str9,criteria.str10,criteria.multiselect5.length,criteria.multiselect5
      ],
      :select => "crm_activities.*,crm_accounts.name as account_number,crm_contacts.first_name as crm_contact_name,users.first_name as user_name")
                                                                
  end
  def self.show_activities(activity_id)
    Crm::CrmActivity.find_by_id(activity_id)
  end

  def self.create_activities(doc)
    activities = [] 
    (doc/:crm_activities/:crm_activity).each{|acct_doc|
      activity = create_activity(acct_doc)
      activity = Crm::CrmActivity.new if !activity
      activities <<  activity if activity
    }
    activities
  end

  def self.create_activity(doc)
    activity = add_or_modify_activity(doc)
    activity.generate_trans_no('CRMACT') if activity.new_record?     
    return  if !activity
    return activity if !activity.errors.empty?
    save_proc = Proc.new{
      if activity.new_record?
        activity.save!
      else
        activity.save!
        activity.save_lines
      end
    }
    activity.save_transaction(&save_proc)
    activity
  end

  def self.add_or_modify_activity(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first  
    activity = Crm::CrmActivity.find_or_create(id) 
    return if !activity
    return activity if activity.view_only
    activity.apply_attributes(doc)
    activity.fill_default_header_values() if activity.new_record?
    crm_task_description = parse_xml(doc/:crm_tasks/:crm_task/'description') 
    #    crm_opportunity_description = parse_xml(doc/:crm_opportunities/:crm_opportunity/'description')
    #    crm_opportunity_name = parse_xml(doc/:crm_opportunities/:crm_opportunity/'name')     
    activity.run_block do
      if crm_task_description != nil and crm_task_description.length > 0
        build_activity_lines(doc/:crm_tasks/:crm_task)
      end
      #      if crm_task_description != nil and (crm_opportunity_description.length > 0 || crm_opportunity_name.length > 0)
      #        build_activity_lines(doc/:crm_opportunities/:crm_opportunity)
      #      end
    end
    activity 
  end
end
