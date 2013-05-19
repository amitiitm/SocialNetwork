class GeneralLedger::GlSetupCrud
 include General

def self.show_gl_setup
  GeneralLedger::GlSetup.find(:all)
end

def self.create_gl_setups(doc)
  gl_setups = [] 
  (doc/:gl_setups/:gl_setup).each{|gl_setup_doc|
  gl_setup = create_gl_setup(gl_setup_doc)
  if gl_setup
    gl_setups <<  gl_setup 
  end
  }
  return gl_setups
end

def self.create_gl_setup(gl_setup_doc)
  gl_setup = add_or_modify(gl_setup_doc) 
  return  if !gl_setup
  return gl_setup if !gl_setup.errors.empty?
  gl_setup.apply_header_fields_to_lines  
  save_proc = Proc.new{
    if gl_setup.new_record?
      gl_setup.save!
    else
      gl_setup.save! 
      gl_setup.gl_setup_items.save_line
    end       
  }
  gl_setup.save_transaction(&save_proc)
  return gl_setup
end
  
def self.add_or_modify(doc)  
  id =  parse_xml(doc/'id') if (doc/'id').first  
  gl_setup = GeneralLedger::GlSetup.find_or_create(id) 
    return if !gl_setup
  gl_setup.apply_attributes(doc) 
  gl_setup.fill_default_header_values()      
  gl_setup.build_lines(doc/:gl_setup_items/:gl_setup_item)   
  return gl_setup 
end

end






