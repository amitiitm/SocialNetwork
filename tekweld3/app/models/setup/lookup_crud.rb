class Setup::LookupCrud < Crud
include General
  
  def self.list_lookups()
    lookups = Setup::Lookup.find(:all,
#                      :conditions => ["code between ? and ? AND
#                                      name between ? and ? AND
#                                      trans_flag between ? and ?
#                                      " ,criteria.str1,criteria.str2,
#                                       criteria.str3, criteria.str4, criteria.str5[0,1], criteria.str6[0,1]],
                      :order => "id")
                      
    if lookups.nil? 
      lookups = Setup.Lookup.new
    end
    lookups
  end

  def self.update_version(lookup_name)
    lookup = Setup::Lookup.find_by_name(lookup_name)
    return  if !lookup
    lookup[:version] = lookup[:version] + 1
    save_proc = Proc.new{
        lookup.save! 
    }
    lookup.save_transaction(&save_proc)
  end
  
end
