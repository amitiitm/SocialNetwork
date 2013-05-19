
module ExtendAssosiation
  def find_or_build(obj_id)
   is_blank_id?(obj_id) ? self.build : to_ary.find { |li| li.id == obj_id.to_i }
  end
   
 def applied_lines
   to_ary.find_all { |li| li.trans_flag == 'A' }  
 end
 
 def save_line
  self.each{|li| li.save!}
 end
 
def delete_line  
  self.each{|line|
    line.destroy if line.trans_flag == 'D'
  }
 end 
 
  def is_blank_id?(obj_id)
    obj_id ? (obj_id.empty? or obj_id.to_i == 0) : :true
  end
  
  def maximum_serial_no
   lno = self.maximum(:serial_no).to_i 
   lno > 0 ? lno : 100 
  end
 
end
  