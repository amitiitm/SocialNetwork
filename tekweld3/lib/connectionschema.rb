module Connectionschema
  
  def Connectionschema.establish_connection_schema(schema_name)
    options = fetch_db_specific_params(schema_name)
    ActiveRecord::Base.establish_connection(
      ActiveRecord::Base.configurations[Rails.env].merge(options)
    )
  end
 
  #multi adapter change
  def self.fetch_db_specific_params(schema_name)
#    if ActiveRecord::Base.retrieve_connection.class.to_s.match('IBM_DBAdapter')
#      options = {'schema' => "#{schema_name}"}
#    end
#    if ActiveRecord::Base.retrieve_ActiveRecord::Baseconnection.class.to_s.match('SQLServerAdapter')
      options = {'schema' => "#{schema_name}"}
      options = {'database' => "#{schema_name}"}
#    end
    options
  end

  
end
