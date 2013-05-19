module UserStamp  
  def self.append_features(base)    
    base.before_create do |base_class|      
      base_class.created_by = Admin::User.current_user if base_class.respond_to?(:created_by) && !Admin::User.current_user.nil?    
      base_class.update_flag ||= 'Y'
      base_class.trans_flag ||= 'A'
      base_class.created_at = Time.now()
      base_class.lock_version = 0
    end    

    base.before_save do |base_class|      
      base_class.updated_by = Admin::User.current_user if base_class.respond_to?(:updated_by) && !Admin::User.current_user.nil?    
      base_class.updated_at = Time.now()
    end  

  
  end
end