class Setup::CriteriaCrud < Crud
include General

  def self.list_by_user_doc(doc)
    user_id =  parse_xml(doc/:criteria/'user_id') if (doc/:criteria/'user_id').first
    document_id =  parse_xml(doc/:criteria/'document_id') if (doc/:criteria/'document_id').first
#    criterias = Setup::Criteria.active.find(:all,
#                       :joins => "join criteria_users b on b.criteria_id = criterias.id ",
#                       :select=>'criterias.*,b.default_yn',
#                       :conditions => [" criterias.document_id = ?  " ,document_id])
#
#multi adapter change
#    criterias = Setup::Criteria.active.find_by_sql ["select criterias.*, Isnull(default_yn, 'N') as default_yn from criterias
#	left outer join criteria_users on
#	(
#		criterias.id = criteria_users.criteria_id
#		and criteria_users.user_id = ?
#	)
#        where criterias.document_id =?
#        order by criterias.name",user_id.to_i,document_id.to_i]
    sql = "select criterias.*, nvl(default_yn, 'N') as default_yn from criterias
	left outer join criteria_users on
	(
		criterias.id = criteria_users.criteria_id
		and criteria_users.user_id = ?
	)
        where criterias.document_id =?
        order by criterias.name"
    sql = convert_sql_to_db_specific(sql)
    criterias = Setup::Criteria.active.find_by_sql [sql,user_id.to_i,document_id.to_i]
    criterias
  end

  def self.show_criteria(criteria_id)
    Setup::Criteria.active.find_all_by_id(criteria_id)
  end

  def self.create_criterias(doc)
    criterias = []
    (doc/:criterias/:criteria).each{|criteria_doc|
      criteria = create_criteria(criteria_doc)
        criterias <<  criteria if criteria
    }
    criterias
  end

  def self.create_criteria(doc)
    criteria = add_or_modify(doc)
    return  if !criteria
    user_id = parse_xml(doc/'user_id') if (doc/'user_id').first
    document_id = parse_xml(doc/'document_id') if (doc/'document_id').first
    default_yn =  parse_xml(doc/'default_yn') if (doc/'default_yn').first
    puts default_yn + '@@@@@@@@@@@@@'
    if default_yn == 'Y'
      criteria_id = criteria[:id]
      criteria_id ||= 0
      criteria_users = Setup::CriteriaUser.find(:all,
                            :conditions => ["user_id = ? and document_id = ? and criteria_id <> ?" ,
                                            user_id, document_id, criteria_id]
                                   )
    end
    save_proc = Proc.new{
      if criteria.new_record?
        criteria.save!
        criteria_users.each{|row|
          row[:default_yn] = 'N'
          row.save!
        }
      else
        criteria.save!
#        criteria.criteria_users.save_line
        criteria_users.each{|row|
          row[:default_yn] = 'N'
          row.save!
        }
      end
    }
    criteria.save_transaction(&save_proc)
    return criteria
  end

  def self.add_or_modify(doc)
    name =  parse_xml(doc/'name') if (doc/'name').first
    #user_id = parse_xml(doc/'user_id') if (doc/'user_id').first
    document_id = parse_xml(doc/'document_id') if (doc/'document_id').first
    criteria = Setup::Criteria.find_by_name_and_document_id(name,document_id)
    lock_version = criteria.lock_version if criteria
    if criteria == nil
       criteria = Setup::Criteria.new
    end
    return if !criteria
    criteria.apply_attributes(doc)
    criteria.lock_version =lock_version
    criteria.add_criteria_users(doc)
    return criteria
  end

end
