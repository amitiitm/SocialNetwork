class ActiveRecord::Base
=begin
    before_create :createdby, :createdat
    before_update :updatedby, :updatedat


    private 
    def updatedby
        if nil != Thread.current["user"].id && self.respond_to?(:updated_by)  
         self[:updated_by] = Thread.current["user"].id
        end
    end
    def updatedat  
      if self.respond_to?(:updated_at) 
       self[:updated_at] = Time.now
      end
    end

    def createdby  
          if nil != Thread.current["user"].id && self.respond_to?(:created_by) 
           self[:created_by] = Thread.current["user"].id
          end
    end 
    def createdat  
        if self.respond_to?(:created_at) 
         self[:created_at] = Time.now
        end
    end 
=end
end