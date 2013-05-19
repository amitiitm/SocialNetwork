module ActiveRecord
  class BaseWithoutTable 
    def attributes
      attributes_hash = Hash.new
      self.instance_variables.each{|var|
        attributes_hash[var[1..var.length-1]]=self.instance_variable_get(var)
      }
      return attributes_hash
    end
  end
end
