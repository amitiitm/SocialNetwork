class Setup::Criteria < ActiveRecord::Base
  #  require 'has_finder'
  include UserStamp
  include Dbobject
  include General
  has_many :criteria_users, :class_name => 'Setup::CriteriaUser' , :extend=>ExtendAssosiation
  set_table_name "criterias"
  def self.fill_criteria(criteria_string)
    criteria = new
    puts criteria
    default_request = parse_xml(criteria_string/:default_request) if (criteria_string/:default_request).first
    if default_request == 'N'
      criteria.apply_attributes(criteria_string)
    else
      user_id = parse_xml(criteria_string/:user_id) if (criteria_string/:user_id).first
      document_id = parse_xml(criteria_string/:document_id) if (criteria_string/:document_id).first
      criteria_user= Setup::CriteriaUser.find(:first,
        :conditions => ["default_yn = 'Y' and
                                      user_id = ? and
                                      document_id = ?",user_id, document_id]   )
      if criteria_user
        id = criteria_user.criteria_id
        criteria = active.find(:first,
          :conditions => ["id=?",id] )
      else
        criteria = active.find(:first,
          :conditions => [" document_id = ? ",document_id],
          :order => 'name')
      end
    end
    criteria.user_id=parse_xml(criteria_string/:user_id) if criteria
    criteria.company_id=parse_xml(criteria_string/:company_id) if criteria
    if criteria.nil?
      criteria = new
    end
    criteria.attributes.each_pair{ |column_name,column_value|
      #      criteria[column_name] = nulltoblank(column_value) if column_name[0,3] == 'str' and column_name[3,2].to_i.odd?
      #      criteria[column_name] = column_value ||='zzzz' if column_name[0,3] == 'str' and column_name[3,2].to_i.even?
      #      criteria[column_name] = nulltozero(column_value) if column_name[0,3] == 'int'  and column_name[3,2].to_i.odd?
      #      criteria[column_name] = column_value ||= 9999 if column_name[0,3] == 'int' and column_name[3,2].to_i.even?
      #      criteria[column_name] = nulltozero(column_value) if column_name[0,3] == 'dec' and column_name[3,2].to_i.odd?
      #      criteria[column_name] = column_value ||=99999.99 if column_name[0,3] == 'dec' and column_name[3,2].to_i.even?
      criteria[column_name] = nulltoblank(column_value) if column_name[0,3] == 'str'
      criteria[column_name] = nulltozero(column_value) if column_name[0,3] == 'int'
      criteria[column_name] = nulltozero(column_value) if column_name[0,3] == 'dec'
      criteria[column_name] = column_value ||='1950-01-01 00:00:00' if column_name[0,2] == 'dt' and column_name[2,2].to_i.odd?
      criteria[column_name] = column_value ||='2999-01-01 00:00:00' if column_name[0,2] == 'dt' and column_name[2,2].to_i.even?
      column_value = ''  if column_name[0,11] == 'multiselect' and !column_value
      criteria[column_name] = column_value.split(",").each {|val| val.strip!}  if column_name[0,11] == 'multiselect'
    }
    #      criteria.company_id=criteria_string/:company_id
    criteria
  end

  def self.fill_criteria_for_query(criteria_string)
    criteria = new
    default_request = parse_xml(criteria_string/:default_request) if (criteria_string/:default_request).first
    if default_request == 'N'
      criteria.apply_attributes(criteria_string)
    else
      user_id = parse_xml(criteria_string/:user_id) if (criteria_string/:user_id).first
      document_id = parse_xml(criteria_string/:document_id) if (criteria_string/:document_id).first
      criteria_user= Setup::CriteriaUser.find(:first,
        :conditions => ["default_yn = 'Y' and
                                      user_id = ? and
                                      document_id = ?",user_id, document_id]   )
      if criteria_user
        id = criteria_user.criteria_id
        criteria = active.find(:first,
          :conditions => ["id=?",id] )
      else
        criteria = active.find(:first,
          :conditions => [" document_id = ? ",document_id],
          :order => 'name')
      end
    end
    criteria.user_id=parse_xml(criteria_string/:user_id) if criteria
    criteria.company_id=parse_xml(criteria_string/:company_id) if criteria
    if criteria.nil?
      criteria = new
    end
    criteria.attributes.each_pair{ |column_name,column_value|
      criteria[column_name] = nulltoblank(column_value) if column_name[0,3] == 'str'&& column_name.gsub('str','').to_i.odd?
      if column_name[0,3] == 'str' && column_name.gsub('str','').to_i.even?  
        if(column_value=='' || column_value==nil)
          criteria[column_name]='zzzz'
        else
          criteria[column_name] = column_value
        end
      end
      criteria[column_name] = nulltozero(column_value) if column_name[0,3] == 'int'
      criteria[column_name] = nulltozero(column_value) if column_name[0,3] == 'dec'
      criteria[column_name] = column_value ||='1950-01-01 00:00:00' if column_name[0,2] == 'dt' and column_name[2,2].to_i.odd?
      criteria[column_name] = column_value ||='2999-01-01 00:00:00' if column_name[0,2] == 'dt' and column_name[2,2].to_i.even?
      value = ''
      column_value = ''  if column_name[0,11] == 'multiselect' and !column_value
      column_value.split(",").each {|val| value +=  val +  "','"}  if column_name[0,11] == 'multiselect'
      criteria[column_name] = ((value.chop).chop).chop if column_name[0,11] == 'multiselect'
      criteria[column_name] = '' if column_name[0,11] == 'multiselect' and criteria[column_name] == nil
    }
    criteria
  end

  def self.fill_criteria_for_sp(criteria_string)
    criteria = new
    default_request = parse_xml(criteria_string/:default_request) if (criteria_string/:default_request).first
    if default_request == 'N'
      criteria.apply_attributes(criteria_string)
    else
      user_id = parse_xml(criteria_string/:user_id) if (criteria_string/:user_id).first
      document_id = parse_xml(criteria_string/:document_id) if (criteria_string/:document_id).first
      criteria_user= Setup::CriteriaUser.find(:first,
        :conditions => ["default_yn = 'Y' and
                                      user_id = ? and
                                      document_id = ?",user_id, document_id]   )
      if criteria_user
        id = criteria_user.criteria_id
        criteria = active.find(:first,
          :conditions => ["id=?",id] )
      else
        criteria = active.find(:first,
          :conditions => [" document_id = ? ",document_id],
          :order => 'name')
      end
    end
    criteria.user_id=parse_xml(criteria_string/:user_id) if criteria
    criteria.company_id=parse_xml(criteria_string/:company_id) if criteria
    if criteria.nil?
      criteria = new
    end
    criteria.attributes.each_pair{ |column_name,column_value|
      criteria[column_name] = nulltoblank(column_value) if column_name[0,3] == 'str'&& column_name.gsub('str','').to_i.odd?
      if column_name[0,3] == 'str' && column_name.gsub('str','').to_i.even?  #kunal
        if(column_value=='' || column_value==nil)
          criteria[column_name]='zzzz'
        else
          criteria[column_name] = column_value
        end
      end
      criteria[column_name] = nulltozero(column_value) if column_name[0,3] == 'int'
      criteria[column_name] = nulltozero(column_value) if column_name[0,3] == 'dec'
      criteria[column_name] = column_value ||='1950-01-01 00:00:00' if column_name[0,2] == 'dt' and column_name[2,2].to_i.odd?
      criteria[column_name] = column_value ||='2999-01-01 00:00:00' if column_name[0,2] == 'dt' and column_name[2,2].to_i.even?
      value = ''
      column_value = ''  if column_name[0,11] == 'multiselect' and !column_value
      column_value.split(",").each {|val| value +=  val + ","}  if column_name[0,11] == 'multiselect'
      criteria[column_name] = value.chop! if column_name[0,11] == 'multiselect'
    }
    criteria
  end

  def add_criteria_users(doc)
    line = criteriausers(doc)|| nil
    apply_user_line_attributes(line,doc) if line
  end

  def criteriausers(doc)
    criteria_id = parse_xml(doc/'/id') if (doc/'/id').first
    sql = "DELETE from criteria_users WHERE criteria_id = #{criteria_id.to_i}"
    ActiveRecord::Base.connection.execute(sql)
    id=''
    line = criteria_users.find_or_build(id)
    line
  end

  def apply_user_line_attributes(line,doc)
    line.user_id = parse_xml(doc/'/user_id').to_i if (doc/'/user_id').first
    line.company_id = parse_xml(doc/'/company_id').to_i if (doc/'/company_id').first
    line.document_id = parse_xml(doc/'/document_id').to_i if (doc/'/document_id').first
    line.default_yn = parse_xml(doc/'/default_yn') if (doc/'/default_yn').first
  end

  def save_lines
    criteria_users.save_line
  end

  def add_line_errors_to_header
    add_line_item_errors(criteria_users)
  end
end