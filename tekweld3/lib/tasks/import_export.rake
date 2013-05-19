#how to call this rake task
#rake import_export:import_to_retail['invn.xlsx','inventory']
namespace :import_export do
  desc "Import/export orders/memos to/from database" 
  task :export_from_retail,[:arg1,:arg2 ]=> :environment do |t,args|
    ImportExport::RetailExport.export_retail_data(args.arg1,args.arg2)#arg1 name of file arg2 name of the event
  end
  
  task :export_from_erp,[:arg1,:arg2 ]=> :environment do |t,args|
    ActiveRecord::Base.establish_connection  'jewel_schema'
    ImportExport::RetailExport.export_erp_data(args.arg1,args.arg2)#arg1 name of file arg2 name of the event
  end
  
  task :import_to_erp,[:arg1,:arg2 ]=> :environment do |t,args|
    ImportExport::ErpImport.import_erp_data(args.arg1,args.arg2)
  end
    
  task :import_to_retail,[:arg1,:arg2 ]=> :environment do |t,args|
    ImportExport::RetailImport.import_retail_data(args.arg1,args.arg2)
  end
end
