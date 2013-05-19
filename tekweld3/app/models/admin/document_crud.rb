
class Admin::DocumentCrud
#  include ContentModelMethods
#  include ClassMethods 
  include General
  
def self.list_documents(doc)
  criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
  document_list = Admin::Document.find(:all,
                    :conditions => ["(code between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} )or (code in ('#{criteria.multiselect1}'))) AND
                                    (document_name between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} )or (document_name in ('#{criteria.multiselect2}'))) AND
                                    (component_cd between '#{criteria.str5}' and '#{criteria.str6}' AND (0 =#{criteria.multiselect3.length} )or (component_cd in ('#{criteria.multiselect3}')))
                                    " ],
                    :order => "id"
                    
                    
  )
  document_list
end


#def self.create_document(doc)
# error_log = []
# documents = []    
# (doc/:documents/:document).each{|document_doc|
#   documents << add_document_values(document_doc)
#  }
#  documents.each {|dc|
#  begin
#    if (not dc.new_record?) and (not dc.menus.empty?) and (dc.trans_flag == 'D')
#      dc.errors.add('Document '+ dc.code + ' : Cannot update. Menu already assigned for this document. ')
#      raise
#    end
#    dc.save!  
#    rescue ActiveRecord::StaleObjectError
#      dc.errors.add( 'Document ' + dc.code + ' : Please refresh --Attempt to access stale objects-- ')
#    rescue Exception
#      error_log.push(dc.errors)
#  end
#  }
#  documents
#end
#
#def self.add_document_values(document_doc)
#  id =  parse_xml(document_doc/'id') if (document_doc/'id').first 
#  document = Admin::Document.find_or_create(id) 
#  document.apply_attributes(document_doc)
#  document
#end

def self.create_documents(doc)
 documents = [] 
 (doc/:documents/:document).each{|docu_type|
   document = create_document(docu_type)
    documents <<  document if document
  }
  documents
end

def self.create_document(doc)
  document = add_or_modify_document(doc) 
  return  if !document
  save_proc = Proc.new{
      document.save! 
    }
  document.save_master(&save_proc)
  return  document
end

def self.add_or_modify_document(doc)
  id =  parse_xml(doc/'id') if (doc/'id').first  
  document = Admin::Document.find_or_create(id) 
  return if !document
  document.apply_attributes(doc) 
  # Add a block to set details
  
  return document
end

def self.show_document(id)
 Admin::Document.find_all_by_id(id)
end

end
