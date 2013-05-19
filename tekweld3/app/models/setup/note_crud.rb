class Setup::NoteCrud
include General

  def self.list_notes(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria) 
    Setup::Note.find(:all,
                     :conditions => ["table_name = ? AND trans_id = ?" ,
                                      criteria.str1,criteria.int1],
                     :order => "created_at DESC"
                    )
  end  

  def self.create_notes(notes_doc)
    notes = [] 
    (notes_doc/:notes/:note).each{|doc|
      note = create_note(doc)
      notes <<  note if note
    }
    notes
  end

  def self.create_note(doc)
    note = add_or_modify_note(doc) 
    return  if !note
    save_proc = Proc.new{
      email = Email::Email.send_email('Notes',note)
      email.save_this_mail  if email
      note.save! 
      }
    note.save_master(&save_proc)
    return  note
  end

  def self.add_or_modify_note(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first  
    note = Setup::Note.find_or_create(id) 
    return if !note
    note.apply_attributes(doc) 
    note.notes_type = 'M'  
    return note 
  end

  def self.create_system_note(table_name,table_id,updated_by,template_code,*args)
    note = add_system_notes(table_name,table_id,updated_by,template_code,*args) 
    return  if !note
    save_proc = Proc.new{
      note.save! 
      }
    note.save_master(&save_proc)
    return  note
  end
  
  def self.add_system_notes(table_name,table_id,updated_by,template_code,*args)
    sysnote =Setup::Note.new
    sysnote.company_id = 1
    sysnote.update_flag = 'V'
    sysnote.table_name = table_name
    sysnote.trans_id = table_id
    sysnote.user_id = updated_by
    sysnote.subject, sysnote.description = Setup::Note.construct_description_from_template(template_code, *args) 
    sysnote.notes_type = 'S' 
    sysnote
  end

  def self.construct_description_from_template(template_code,*args)
    template = Setup::NoteTemplate.find_by_code(template_code)
    if template
      param_count = template.description.count('%')
      description = template.description.gsub('%d','%s')
      description = description.gsub('%i','%s')
      if param_count > args.size
        for i in 0 ... (param_count - args.size)
          args << ''
        end
      end
      description = description%args  if args.size>0
      subject = template.subject 
    end
    return subject,description
  end
  
end
