class Crm::CrmTaskCrud
  include General

  #def self.list_tasks(doc)
  #  criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
  #  Crm::CrmTask.active.find(:all,
  #                    :conditions=>[" trans_date between ? and ? And
  #                                    (location between ? and ? and (0 =? or location in (?))) AND
  #                                    (status between ? and ? and (0 =? or status in (?)))
  #                                   ",
  #                                   criteria.dt1,criteria.dt2,
  #                                   criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1 ,
  #                                   criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2 
  #                                  ])
  #                                                                
  #end
  def self.list_tasks(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
    Crm::CrmTask.find(:all,
      :joins =>"left outer join users on users.id = crm_tasks.assigned_user_id
                              left outer join crm_accounts on crm_accounts.id = crm_tasks.crm_account_id
                              left outer join crm_contacts on crm_contacts.id = crm_tasks.crm_contact_id
      ",
      :conditions=>[" (trans_date between ? and ?) AND
                      (isnull(location,'') between ? and ? and (0 =? or location in (?))) AND
                      (isnull(crm_accounts.account_number,'') between ? and ? and (0 =? or crm_accounts.account_number in (?))) AND
                      (isnull(crm_contacts.first_name,'') between ? and ? and (0 =? or crm_contacts.first_name in (?))) AND
                      (isnull(users.user_cd,'') between ? and ? and (0 =? or users.user_cd in (?))) AND
                      (isnull(crm_tasks.due_date,'1990-01-01 00:00:00') between ? and ? ) AND
                      (isnull(crm_tasks.start_date,'1990-01-01 00:00:00') between ? and ? ) AND
                      (isnull(crm_tasks.end_date,'1990-01-01 00:00:00') between ? and ? ) AND
                      (crm_tasks.status between ? and ? ) AND
                      (crm_tasks.trans_no between ? and ? and (0 =? or crm_tasks.trans_no in (?))) AND
                      (crm_tasks.trans_flag = 'A')
        ",
        criteria.dt1,criteria.dt2,
        criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
        criteria.str3,criteria.str4,criteria.multiselect2.length,criteria.multiselect2,
        criteria.str5,criteria.str6,criteria.multiselect3.length,criteria.multiselect3,
        criteria.str7,criteria.str8,criteria.multiselect4.length,criteria.multiselect4,
        criteria.dt3,criteria.dt4,
        criteria.dt5,criteria.dt6,
        criteria.dt7,criteria.dt8,
        criteria.str9,criteria.str10,
        criteria.str11,criteria.str12,criteria.multiselect6.length,criteria.multiselect6
      ],
      :select => "crm_tasks.id,crm_tasks.trans_bk,crm_tasks.trans_no,crm_tasks.trans_date,crm_tasks.due_date,crm_tasks.start_date,crm_tasks.end_date,
                                  crm_tasks.duration,crm_tasks.location,crm_tasks.subject,crm_tasks.status,
                                  crm_tasks.priority,crm_tasks.description,
                                  users.first_name as crm_user_name,
                                  users.user_cd as crm_user_code,
                                  crm_accounts.name as crm_accout_name,
                                  crm_contacts.first_name as crm_contact_name                                  
      ")
                                                                
  end
  def self.show_tasks(task_id)
    Crm::CrmTask.find_all_by_id(task_id)
  end

  def self.create_tasks(doc)
    tasks = [] 
    (doc/:crm_tasks/:crm_task).each{|acct_doc|
      task = create_task(acct_doc)
      tasks <<  task if task
    }
    tasks
  end

  def self.create_task(doc)
    task = add_or_modify_task(doc)
    task.generate_trans_no('CRMTSK') if task.new_record?    
    return  if !task
    return task if !task.errors.empty?
    save_proc = Proc.new{
      task.save! 
    }
    task.save_master(&save_proc)
    task
  end

  def self.add_or_modify_task(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first  
    task = Crm::CrmTask.find_or_create(id) 
    return if !task
    return task if task.view_only
    task.apply_attributes(doc) 
    task.fill_default_header_values() if task.new_record?    
    task 
  end

end
