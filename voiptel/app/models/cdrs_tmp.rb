class CdrsTmp < ActiveRecord::Base
  def self.table_name
    "cdrs_tmp"
  end
  
  def self.move_back
    for tmp in self.all
      cdr = Cdr.new(tmp.attributes)
      cdr.save
      tmp.delete
    end
  end
end