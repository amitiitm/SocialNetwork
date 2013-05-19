class Setup::AttachmentCrud
include General

  def self.list_attachments(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
    Setup::Attachment.find(:all,
                           :conditions => ["table_name = ? AND trans_id = ?" ,
                                          criteria.str1,criteria.int1
                                          ],
                           :order => "date_added"
    )
  end

  def self.create_attachments(doc,uploaded_file,schema_name)
    file_name,folder_name = IO::FileIO.save_attachment(uploaded_file,schema_name)
    attachment = add_or_modify_attachment(doc/:attachments/:attachment) 
    attachment.folder_name = folder_name if folder_name
    return  if !attachment
    save_proc = Proc.new{
      attachment.save! 
      }
    attachment.save_master(&save_proc)
    return  attachment
  end

  def self.add_or_modify_attachment(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first  
    attachment = Setup::Attachment.find_or_create(id) 
    return if !attachment
    attachment.apply_attributes(doc) 
    return attachment
  end

end

