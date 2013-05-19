class Main::SchemaCrud < Crud
  include Connectionschema
  require 'rake'
  require 'rake/testtask'  
  require 'rake/rdoctask' 
#  require 'tasks/rails'
 
def self.create_schema(schema_name)
#    Connection.establish_connection_main
    Connectionschema.establish_connection_schema('main')
    #ActiveRecord::Base.connection.execute("create schema #{schema_name}")
    create_sql = fetch_db_specific_create_sql(schema_name)
    ActiveRecord::Base.connection.execute(create_sql)
    perform_db_specific_setups(schema_name)
    Connectionschema.establish_connection_schema(schema_name)
     begin
#     Creates database tables.
      Rake::Task["db:migrate"].invoke  
      Rake::Task['db:migrate'].reenable
#     Populates tables with initial data.
      Rake::Task["db:seed"].invoke  
      Rake::Task['db:seed'].reenable
      rescue Exception=>exp
         Rake::Task['db:migrate'].reenable
         Rake::Task['db:seed'].reenable
#         errors = "Error in create schema " + exp.to_s 
          errors = Error.new("Error in #{exp}")
         raise
     end
#     ActiveRecord::Base.clear_active_connections!
end

def self.drop_schema(schema_name)
#    if ActiveRecord::Base.retrieve_connection.class.to_s.match('IBM_DBAdapter')
#     existing_schema = self.check_for_schema(schema_name)
#     if not existing_schema.empty?
#      Connectionschema.establish_connection_schema('main')
#      table_name = ActiveRecord::Base.connection.select_all("select tabname from syscat.tables where tabschema = upper('#{schema_name}')")
#      table_name.each{|tbl|
#        ActiveRecord::Base.connection.execute("drop table #{schema_name}.#{tbl['tabname']}")
#      }
#      ActiveRecord::Base.connection.execute("drop schema #{schema_name} RESTRICT ")
#     end
#   end
#   if ActiveRecord::Base.retrieve_connection.class.to_s.match('SQLServerAdapter')
      ActiveRecord::Base.connection.execute("drop database #{schema_name}")
#   end
end

def self.check_for_schema(schema_name)
  Connectionschema.establish_connection_schema('main')
#  ActiveRecord::Base.connection.select_all("SELECT name FROM SYSIBM.SYSSCHEMATA where name=upper('#{schema_name}')") if ActiveRecord::Base.retrieve_connection.class.to_s.match('IBM_DBAdapter')
  ActiveRecord::Base.connection.select_all("SELECT name FROM sys.sysdatabases where name='#{schema_name}'") #if ActiveRecord::Base.retrieve_connection.class.to_s.match('SQLServerAdapter')
end  

def self.fetch_db_specific_create_sql(schema_name)
#  if ActiveRecord::Base.retrieve_connection.class.to_s.match('IBM_DBAdapter')
#    create_sql = {'schema' => "#{schema_name}"}
#  end
#  if ActiveRecord::Base.retrieve_connection.class.to_s.match('SQLServerAdapter')
    filename = "'C:\\Program Files\\Microsoft SQL Server\\MSSQL.1\\MSSQL\\DATA\\#{schema_name}.mdf'"
    log_filename = "'C:\\Program Files\\Microsoft SQL Server\\MSSQL.1\\MSSQL\\DATA\\#{schema_name}_log.ldf'"
    create_sql = 
      "
                CREATE DATABASE [#{schema_name}] ON  PRIMARY 
                ( NAME = N'#{schema_name}', FILENAME = N#{filename} , SIZE = 2048KB , FILEGROWTH = 1024KB )
                 LOG ON 
                ( NAME = N'#{schema_name}_log', FILENAME = N#{log_filename} , SIZE = 2048KB , FILEGROWTH = 10%)
    "
#  end
  puts create_sql
  create_sql
end

def self.perform_db_specific_setups(schema_name)
  Connectionschema.establish_connection_schema(schema_name)
#  if ActiveRecord::Base.retrieve_connection.class.to_s.match('IBM_DBAdapter')
#  end
#  if ActiveRecord::Base.retrieve_connection.class.to_s.match('SQLServerAdapter')
    #create a scalar function in SQLServer database.
    create_sql = "Create   Function [dbo].[concat] 
                          (
                          @string1		char(100),
                          @string2		char(100)
                          )
                  Returns char(200)

                  Begin

                          Return rtrim(@string1) + rtrim(@string2)
                  End
                "
    ActiveRecord::Base.connection.execute(create_sql)    
    
    #create a scalar function in SQLServer database.
    create_sql = "Create Function [dbo].[upcase] 
                          (
                          @string1		char(100)
                          )
                  Returns char(100)

                  Begin

                          Return upper(rtrim(@string1))
                  End
                "
    ActiveRecord::Base.connection.execute(create_sql)   
  #Newly added by Minal
  create_sql = "Create   Function [dbo].[trim] 
                          (
                          @string1		varchar(100)
                         
                          )
                  Returns varchar(100)

                  Begin

                          Return rtrim(@string1)
                  End
                "
    ActiveRecord::Base.connection.execute(create_sql)  
    
    create_sql = "Create   Function [dbo].[length] 
                          (
                          @string1		varchar(100)
                         
                          )
                  Returns int

                  Begin

                          Return len(@string1)

                  End   
                "
    ActiveRecord::Base.connection.execute(create_sql)  
    create_sql = "Create Function [dbo].[substr] 
                          (
                          @string		varchar(200)  ,
                          @start  int ,
                          @length  int

                          )
                  Returns char(200)

                  Begin

                          Return (substring(@string,@start,@length))
                  End
 
                "
    ActiveRecord::Base.connection.execute(create_sql)  
    
     create_sql = "Create  Function [dbo].[locate] 
                          (
                          @string1		varchar(100) ,
                          @string2		varchar(100)
                         
                          )
                  Returns int

                  Begin

                          Return charindex(@string1,@string2)
                  End

 
                "
    ActiveRecord::Base.connection.execute(create_sql)
    
#  end
  Connectionschema.establish_connection_schema('main')
end

end
