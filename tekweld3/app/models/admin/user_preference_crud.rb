class Admin::UserPreferenceCrud
include General

def self.save_preference(preference_doc)
  userpreference = add_userpreference(preference_doc)
  set_preferences(preference_doc,userpreference)
  begin      
    Admin::UserPreference.transaction() do
      userpreference.save
  end
  rescue ActiveRecord::StaleObjectError
    userpreference.errors.add('Already updated!!!')
  rescue Exception
    return userpreference 
  end
  userpreference 
end  

 def self.add_userpreference(preference_doc)
  user_id = parse_xml(preference_doc/'user_id')   if (preference_doc/'user_id').first
  document_id = parse_xml(preference_doc/'document_id')   if (preference_doc/'document_id').first
  user_pref = Admin::UserPreference.find(:first, :conditions=>["user_id = ? and document_id = ?",user_id,document_id]) 
  if user_pref.nil?
     user_pref = Admin::UserPreference.new
     user_pref['user_id'] = user_id
     user_pref['document_id']=document_id
  end
  user_pref
 end
 
def self.set_preferences(preference_doc,user_preference)
  user_preference.apply_attributes(preference_doc)
  user_preference["company_id"] = 1
 end
 
def self.find_userpreference(doc) 
  user_id = parse_xml(doc/'user_id')   if (doc/'user_id').first
  document_id = parse_xml(doc/'document_id')   if (doc/'document_id').first
  userpreference = Admin::UserPreference.find(:first, :conditions=>["user_id = ? and document_id = ?",user_id,document_id]) 
  if userpreference.nil?
    userpreference = add_userpreference(doc)
  end  
  userpreference
end
  
def self.update_last_moodule(doc) 
  error = 'F'
  user_id = parse_xml(doc/:criteria/'user_id')   if (doc/:criteria/'user_id').first
  moodule_id = parse_xml(doc/:criteria/'moodule_id')  if (doc/:criteria/'moodule_id').first

  user = Admin::User.find_by_id(user_id) if user_id
  user.last_moodule_id = moodule_id  if user
  user.save
  rescue ActiveRecord::RecordInvalid 
      error = 'T'
      
  error
end
 
end
