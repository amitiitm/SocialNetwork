
module GenericSelects
  def self.included(base) 
    base.has_finder :by_code_name_trans_flag,lambda{|criteria|{ 
                             :conditions => ["(trans_flag ='A')AND
                                              (code between ? and ? AND (0 =? or code in (?) ) ) AND
                                              (name between ? and ? AND (0 =? or name in (?) ) )  " ,
                                               criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1,
                                               criteria.str3, criteria.str4,criteria.multiselect2.length,criteria.multiselect2 ] }}
    super
    base.extend(GenericClassMethods)
end

module GenericClassMethods

  def find_by_code_name_trans_flag(criteria)
      self.by_code_name_trans_flag(criteria)
  #    find(:all,
  #       :conditions => ["code between ? and ? AND
  #                      name between ? and ? AND
  #                      trans_flag between ? and ?
  #                      " ,criteria.str1,criteria.str2,
  #                       criteria.str3, criteria.str4, criteria.str5[0,1], criteria.str6[0,1]]                 
  #  )
  end 

  def find_by_trans_bk_no_date(trans_bk,trans_no,trans_date,company_id)
#   find(:all,:conditions => ["trans_bk = ? and
#                  trans_no = ? and
#                  cast(trans_date as date) =?
                  ##", trans_bk,trans_no,trans_date]) if ActiveRecord::Base.retrieve_connection.class.to_s.match('IBM_DBAdapter')
    find(:all,:conditions => ["trans_bk = ? and
                  trans_no = ? and
                  trans_date = ? 
                  ", trans_bk,trans_no,trans_date]) #if ActiveRecord::Base.retrieve_connection.class.to_s.match('SQLServerAdapter')
  end
  
  def find_by_trans_bk_no(trans_bk,trans_no)          
    find(:all,:conditions => ["trans_bk = ? and trans_no = ? ", trans_bk,trans_no]) 
  end

  def find_id_by_code(code)
    (base_object = find_by_code(code)) ? base_object.id : nil
  end
  
  def find_first_by_condition(*args)
    resultset = find(:all,
           :conditions => [*args])
    resultset.empty? ?  nil :resultset.first
  end
  
end
end
