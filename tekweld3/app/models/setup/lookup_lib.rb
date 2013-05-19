class Setup::LookupLib
  include General

  #  def self.list(doc)
  #    row_name = parse_xml(doc/:criteria/:lookupname) if (doc/:criteria/:lookupname).first  
  #    user_id= parse_xml(doc/:criteria/:user_id) if (doc/:criteria/:user_id).first
  #    #     row_name='UserStoreAccess'
  #    #     user_id = 100
  #    case row_name
  #    when 'User'
  #      list = Admin::User.find(:all,
  #        :order => "user_cd",
  #        :select => "id, user_cd as code, first_name  as name",
  #        :conditions => "trans_flag ='A'")
  #    when 'CompanyStore'
  #      list = Setup::Company.find(:all,
  #        :order => "code",
  #        :select => "id, company_cd as code, name",
  #        :conditions => "trans_flag ='A'")
  #    when 'AccountPeriod'
  #      list = Setup::AccountPeriod.find( :all, 
  #        :select => "id, code, description as name",
  #        :conditions => "trans_flag ='A' and gl='O'")
  #    when 'GlCategory'
  #      list = GeneralLedger::GlCategory.find(:all,         
  #        :select => "id, code, name",
  #        :conditions => "trans_flag ='A'")
  #    when 'GLAccount'
  #      list = GeneralLedger::GlAccount.find(:all, 
  #        :conditions => "acct_flag != 'B' and trans_flag='A' ",
  #        :select => "id, code, name")
  #    when 'GLBankAccount'
  #      list = GeneralLedger::GlAccount.find(:all, 
  #        :conditions => "acct_flag ='B' and trans_flag='A' ",
  #        :select => "id, code, name ")                       
  #
  #    when 'Bank'
  #      list = GeneralLedger::Bank.find(:all, 
  #        :select => "id, code, name",
  #        :conditions => "trans_flag ='A'")
  #                               
  #    when 'CustomerCategory'
  #      list = Customer::CustomerCategory.find(:all,
  #        :order => "name",
  #        :select => "id, code, name",
  #        :conditions => "trans_flag ='A'")
  #    when 'Customer'
  #      if id == nil then id = 0 end
  #      master_access = Customer::Customer.find_by_sql ["select value from types where type_cd = 'master_access' and subtype_cd = 'customer'"]
  #      if master_access 
  #        list = Customer::Customer.find(:all, 
  #          :select => "id, code, name",
  #          :conditions=>["trans_flag='A' and company_id in (select company_id from user_companies where user_id = ?) OR ascii('All') = ascii(?)",user_id,master_access.first.value])
  #      else
  #        list = Customer::Customer.find(:all, 
  #          :select => "id, code, name",
  #          :conditions => "trans_flag ='A'")
  #      end
  #      ## newly added on 29 july 2011 by amit
  #    when 'RetailCustomer'
  #      if id == nil then id = 0 end
  #      master_access = Customer::Customer.find_by_sql ["select value from types where type_cd = 'master_access' and subtype_cd = 'customer'"]
  #      if master_access 
  #        list = Customer::Customer.find(:all, 
  #          :select => "id, code, name",
  #          :conditions=>["customer_type = 'R' and trans_flag='A' and company_id in (select company_id from user_companies where user_id = ?) OR ascii('All') = ascii(?)",user_id,master_access.first.value])
  #      else
  #        list = Customer::Customer.find(:all, 
  #          :select => "id, code, name",
  #          :conditions => "customer_type = 'R' and trans_flag ='A'")
  #      end
  #    when 'CustomerShipping'
  #      list = Customer::CustomerShipping.find(:all,
  #        :order => "customer_shippings.name",
  #        :select => "customer_shippings.id, customer_shippings.code, customer_shippings.name, customer_shippings.customer_id,customers.code as customer_code",
  #        :joins => "inner join customers on customers.id = customer_shippings.customer_id",
  #        :conditions => "customer_shippings.trans_flag ='A'")
  #      ## newly added on 29 july 2011 by amit
  #    when 'RetailCustomerShipping'
  #      list = Customer::CustomerShipping.find(:all,
  #        :order => "customer_shippings.name",
  #        :select => "customer_shippings.id, customer_shippings.code, customer_shippings.name,customer_shippings.customer_id,customers.code as customer_code",
  #        :joins => "inner join customers on customers.id = customer_shippings.customer_id",
  #        :conditions => "customers.customer_type = 'R' and customer_shippings.trans_flag ='A'")
  #    when 'Salesperson'
  #      list = Customer::Salesperson.find(:all,
  #        :order => "name",
  #        :select => "id, code, name",
  #        :conditions => "trans_flag ='A'")
  #    when 'Purchaseperson'
  #      list = Vendor::Purchaseperson.find(:all,
  #        :order => "name",
  #        :select => "id, code, name",
  #        :conditions => "trans_flag ='A'")
  #                                    
  #    when 'Labor'
  #      list = Inventory::Labor.find( :all, 
  #        :select => "id, code ,code as name",
  #        :conditions => "trans_flag ='A'")
  #      
  #    when 'VendorCategory'
  #      list = Vendor::VendorCategory.find(:all,
  #        :order => "name",
  #        :select => "id, code, name",
  #        :conditions => "trans_flag ='A'")
  #    when 'Vendor'
  #      #        master_access = Customer::Customer.find_by_sql ["select value from types where type_cd = 'master_access' and subtype_cd = 'customer'"]
  #      #        if master_access 
  #      #        list = Vendor::Vendor.find(:all,
  #      #          :select => "id, code, name",
  #      #          :conditions=>["company_id in (select company_id from user_companies where user_id = ?) OR ascii('All') = ascii(?)",user_id,master_access.first.value])
  #      #      else
  #      list = Vendor::Vendor.active.find(:all, 
  #        :select => "id, code, name")
  #      #      end
  #    when 'Term'
  #      list = Setup::Term.find(:all, 
  #        :select => "id, code, name",
  #        :conditions => "trans_flag ='A'")
  #    when 'Item'
  #      list = Item::CatalogItem.find(:all, 
  #        :select => "id, store_code as code, name",
  #        :conditions => "trans_flag ='A'")
  #    when 'SetupItem'
  #      list = Item::CatalogItem.find(:all, 
  #        :select => "id, store_code as code, name,cost,sale_description as description,unit",
  #        :conditions => "trans_flag ='A' and item_type = 'S'")
  #    when 'AccessoriesItem'
  #      list = Item::CatalogItem.find(:all, 
  #        :select => "id, store_code as code, name,cost,sale_description as description,unit",
  #        :conditions => "trans_flag ='A' and item_type = 'C'")
  #    when 'AssembleItem'
  #      list = Item::CatalogItem.find(:all, 
  #        :select => "id, store_code as code, name,cost,sale_description as description,unit",
  #        :conditions => "trans_flag ='A' and item_type = 'A'")
  #    when 'ItemGroup'
  #      list = Item::CatalogGroup.find(:all, 
  #        :select => "id, code, name")
  #    when 'ItemCategory'
  #      list = Item::CatalogItemCategory.find(:all, 
  #        :select => "id, code, name",
  #        :conditions => "trans_flag ='A'")
  #    when 'Shipping'
  #      list = Setup::Shipping.find(:all, 
  #        :select => "id, code, name",
  #        :conditions => "trans_flag ='A'")
  #    when 'Location'
  #      list = Item::Location.find(:all, 
  #        :select => "id, code, name",
  #        :conditions => "trans_flag ='A'")
  #    when 'CrmAccount'
  #      list = Crm::CrmAccount.find(:all,
  #        :select => "id, account_number as code, name",
  #        :conditions => "trans_flag ='A'")
  #    when 'CrmContact'
  #      list = Crm::CrmContact.find(:all,
  #        :select => "id,id as code,first_name +' '+ last_name as name,crm_account_id",
  #        :conditions => "trans_flag ='A'")
  #                          
  #    when 'CrmTask'
  #      list = Crm::CrmTask.find(:all,
  #        :select => "id, crm_account_id",
  #        :conditions => "trans_flag ='A'")
  #                         
  #    when 'CrmAccountCategory'
  #      list = Crm::CrmAccountCategory.find(:all,
  #        :select => "id, code,name",
  #        :conditions => "trans_flag ='A'")
  #                          
  #    when 'CrmOpportunity'
  #      list = Crm::CrmOpportunity.find(:all,
  #        :select => "id, id as code, name",
  #        :conditions => "trans_flag ='A'")
  #                         
  #    when 'DiamondCategory'
  #      list = Diamond::DiamondCategory.find( :all, 
  #        :select => "id, code , name",
  #        :conditions => "trans_flag ='A'")
  #    when 'DiamondLot'
  #      list = Diamond::DiamondLot.find( :all, 
  #        :select => "id, lot_number as code, description as name",
  #        :conditions => "trans_flag ='A'")
  #    when 'DiamondPacket'
  #      list = Diamond::DiamondPacket.find( :all, 
  #        :joins => "as a inner join diamond_lots as b on a.diamond_lot_id = b.id " ,
  #        :select => "a.id, a.packet_no as packet_no , b.lot_number as lot_number ",
  #        :conditions => "trans_flag ='A'")
  #    when 'CatalogAttribute'
  #      list = Item::CatalogAttribute.find(:all, 
  #        :select => "id, code, name",
  #        :conditions => "trans_flag ='A'")
  #    when 'CatalogAttributeValue'
  #      list = Item::CatalogAttributeValue.find(:all, 
  #        :select => "id, code, name, catalog_attribute_id",
  #        :conditions => "trans_flag ='A'")
  #    when 'Document'
  #      list = Admin::Document.find(:all,
  #        :order => "document_name",
  #        :select => "id, code, document_name, component_cd",
  #        :conditions => "trans_flag ='A'")
  #                                    
  #    when 'Lab'
  #      list = Vendor::Vendor.find(:all,
  #        :select => "id, code, name",
  #        :conditions => "lab_yn = 'Y' and trans_flag='A'"
  #      )
  #                          
  #    when 'Role'
  #      list = Admin::Role.find(:all,
  #        :select => "id, code,role_name as name",
  #        :conditions => "trans_flag= 'A'"
  #      )     
  #    when 'Moodule'
  #      list = Admin::Moodule.find(:all,
  #        :select => "id, code,moodule_name as name",
  #        :conditions => "trans_flag= 'A'"
  #      )
  #    when 'Menu'
  #      list = Admin::Menu.find(:all,
  #        :select => "id, code,menu_name as name,moodule_id,menu_type",
  #        :conditions => "trans_flag= 'A'"
  #      )                                      
  #    when 'CatalogOrderStatus'
  #      list = Setup::Type.find(:all,
  #        :select => "id, value as code, description as name",
  #        :conditions => " type_cd = 'catalog_order_status'
  #                                               and subtype_cd = 'value' and trans_flag='A'"
  #      )
  #    when 'MeltingRetailer'
  #      list = Metal::MeltingRetailer.active.find(:all, 
  #        :select => "id, code, name")
  #    when 'WorkbagStages'
  #      list = Workbag::WorkbagStage.find(:all,
  #        :select => "id, code,name,allow_transfer",
  #        :order => "sequence_no",
  #        :conditions => "trans_flag = 'A'"
  #      )
  #    when 'UserStoreAccess'
  #      #        list = Admin::UserCompany.find(:all,
  #      #                                      :joins =>"inner join companies on companies.id=user_companies.company_id ",
  #      #                                      :order => "id",
  #      #                                      :select => "user_companies.*",
  #      #                                      :conditions=>["user_id=?",user_id] )   
  #      #      list = Setup::CompanyStore.find(:all,
  #      #                                      :order => "code",
  #      #                                      :select => "id, code, name",
  #      #                                      :conditions=>["user_id=?",user_id] )  
  #      list = Setup::Company.find_by_sql ["select id,company_cd as code,name from companies where companies.trans_flag ='A' and id in (select company_id from user_companies where user_id = ?)",user_id]
  #    when 'MeltingStageMaster'
  #      list = Metal::MeltingTransaction.find_by_sql ["select id,stage_code as code,stage_name as name from melting_stage_master where melting_stage_master.trans_flag ='A'"]
  #    else
  #    end
  #    if list.nil? 
  #      list =  Setup::Lookup.new
  #    end
  #    list
  #  end
  
  def self.list(doc)
    row_name = parse_xml(doc/:criteria/:lookupname) if (doc/:criteria/:lookupname).first  
    user_id= parse_xml(doc/:criteria/:user_id) if (doc/:criteria/:user_id).first
    #     row_name='UserStoreAccess'
    #     user_id = 100
    case row_name
    when 'User'
      list = Admin::User.find_by_sql ["select CAST(( 
                                  select(select id, user_cd as code, first_name  as name from users
                                  where trans_flag = 'A' order by  user_cd
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
    when 'CompanyStore'
      list = Setup::Company.find_by_sql ["select CAST(( 
                                  select(select id, company_cd as code, name from companies
                                  where trans_flag = 'A'
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
    when 'AccountPeriod'
      list = Setup::AccountPeriod.find_by_sql ["select CAST(( 
                                  select(select id, code, description as name from account_periods
                                  where trans_flag = 'A' and gl='O'
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]

    when 'GlCategory'
      list = GeneralLedger::GlCategory.find_by_sql ["select CAST(( 
                                  select(select id, code, name from gl_categories
                                  where trans_flag = 'A'
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]

    when 'GLAccount'
      list = GeneralLedger::GlAccount.find_by_sql ["select CAST(( 
                                  select(select id, code, name from gl_accounts
                                  where acct_flag != 'B' and trans_flag='A'
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]

    when 'GLBankAccount'
      list = GeneralLedger::GlAccount.find_by_sql ["select CAST(( 
                                  select(select id, code, name from gl_accounts
                                  where acct_flag = 'B' and trans_flag='A'
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
                    

    when 'Bank'
      list = GeneralLedger::Bank.find_by_sql ["select CAST(( 
                                  select(select id, code, name from banks
                                  where  trans_flag='A'
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
                               
    when 'CustomerCategory'
      list = Customer::CustomerCategory.find_by_sql ["select CAST(( 
                                  select(select id, code, name from customer_categories
                                  where  trans_flag='A' order by name
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]

    when 'Customer'
#      if id == nil then id = 0 end
      master_access = Customer::Customer.find_by_sql ["select value from types where type_cd = 'master_access' and subtype_cd = 'customer'"]
      if master_access 
        list = Customer::Customer.find_by_sql ["select CAST(( 
                                  select(select id, code, name from customers
                                  where  trans_flag='A' and company_id in (select company_id from user_companies where user_id = ?) OR ascii('All') = ascii(?)
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol",user_id,master_access.first.value]
      else
        list = Customer::Customer.find_by_sql ["select CAST(( 
                                  select(select id, code, name from customers
                                  where  trans_flag='A' 
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
      end
      ## newly added on 29 july 2011 by amit
    when 'RetailCustomer'
#      if id == nil then id = 0 end
      master_access = Customer::Customer.find_by_sql ["select value from types where type_cd = 'master_access' and subtype_cd = 'customer'"]
      if master_access 
        list = Customer::Customer.find_by_sql ["select CAST(( 
                                  select(select id, code, name from customers
                                  where  trans_flag='A' and company_id in (select company_id from user_companies where user_id = ?) OR ascii('All') = ascii(?)
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol",user_id,master_access.first.value]
      else
        list = Customer::Customer.find_by_sql ["select CAST(( 
                                  select(select id, code, name from customers
                                  where  trans_flag='A' 
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
      end
    when 'CustomerShipping'
      list = Customer::CustomerShipping.find_by_sql ["select CAST(( 
                                  select(select customer_shippings.id, customer_shippings.code, customer_shippings.name, customer_shippings.customer_id,customers.code as customer_code from customer_shippings
                                  inner join customers on customers.id = customer_shippings.customer_id                                  
                                  where  customer_shippings.trans_flag ='A' order by customer_shippings.name
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]

      ## newly added on 29 july 2011 by amit
    when 'RetailCustomerShipping'
      list = Customer::CustomerShipping.find_by_sql ["select CAST(( 
                                  select(select customer_shippings.id, customer_shippings.code, customer_shippings.name, customer_shippings.customer_id,customers.code as customer_code from customer_shippings
                                  inner join customers on customers.id = customer_shippings.customer_id                                  
                                  where  customer_shippings.trans_flag ='A' order by customer_shippings.name
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
    when 'Salesperson'
      list = Customer::Salesperson.find_by_sql ["select CAST(( 
                                  select(select id, code, name,phone1 as phone,email from salespeople
                                  where  trans_flag='A' and category = 'Internal' order by name
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
    when 'ExternalSalesPerson'
      list = Customer::Salesperson.find_by_sql ["select CAST(( 
                                  select(select id, code, name,phone1 as phone,email from salespeople
                                  where  trans_flag='A' and category = 'External' order by name
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
    when 'Purchaseperson'
      list = Vendor::Purchaseperson.find_by_sql ["select CAST(( 
                                  select(select id, code, name from purchasepeople
                                  where  trans_flag='A' order by name
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
                                    
    when 'Labor'
      list = Inventory::Labor.find_by_sql ["select CAST(( 
                                  select(select id, code, code as name from labors
                                  where  trans_flag='A' 
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
      
    when 'VendorCategory'
      list = Vendor::VendorCategory.find_by_sql ["select CAST(( 
                                  select(select id, code, name from vendor_categories
                                  where  trans_flag='A' order by name
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
    when 'Vendor'
      list = Vendor::Vendor.find_by_sql ["select CAST(( 
                                  select(select id, code, name from vendors
                                  where  trans_flag='A' order by name
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
    when 'Term'
      list = Setup::Term.find_by_sql ["select CAST(( 
                                  select(select id, code, name from terms
                                  where  trans_flag='A' order by name
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
    when 'Item'
      list = Item::CatalogItem.find_by_sql ["select CAST(( 
                                  select(select id, store_code as code, name from catalog_items
                                  where  trans_flag='A' and item_type = 'I' order by name
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
    when 'SetupItem'
      list = Item::CatalogItem.find_by_sql ["select CAST(( 
                                  select(select id, store_code as code, name,cost,sale_description as description,unit from catalog_items
                                  where  trans_flag ='A' and item_type = 'S' order by name
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]

    when 'AccessoriesItem'
      list = Item::CatalogItem.find_by_sql ["select CAST(( 
                                  select(select id, store_code as code, name,cost,sale_description as description,unit from catalog_items
                                  where  trans_flag ='A' and item_type = 'C' order by name
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
    when 'AssembleItem'
      list = Item::CatalogItem.find_by_sql ["select CAST(( 
                                  select(select id, store_code as code, name,cost,sale_description as description,unit from catalog_items
                                  where  trans_flag ='A' and item_type = 'A' order by name
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
    when 'ItemGroup'
      list = Item::CatalogGroup.find_by_sql ["select CAST(( 
                                  select(select id,code, name from catalog_groups
                                  where  trans_flag ='A' order by name
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
    when 'ItemCategory'
      list = Item::CatalogItemCategory.find_by_sql ["select CAST(( 
                                  select(select id,code, name from catalog_item_categories
                                  where  trans_flag ='A' order by name
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
    when 'Shipping'
      list = Setup::Shipping.find_by_sql ["select CAST(( 
                                  select(select id,code, name from shippings
                                  where  trans_flag ='A' order by name
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
    when 'Location'
      list = Item::Location.find_by_sql ["select CAST(( 
                                  select(select id,code, name from locations
                                  where  trans_flag ='A' order by name
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
    when 'CrmAccount'
      list = Crm::CrmAccount.find_by_sql ["select CAST(( 
                                  select(select id,account_number as code, name from crm_accounts
                                  where  trans_flag ='A' order by name
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
    when 'CrmContact'
      list = Crm::CrmContact.find_by_sql ["select CAST(( 
                                  select(select id,id as code,first_name +' '+ last_name as name,crm_account_id from crm_contacts
                                  where  trans_flag ='A' 
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
                          
    when 'CrmTask'
      list = Crm::CrmTask.find_by_sql ["select CAST(( 
                                  select(select id,crm_account_id from crm_tasks
                                  where  trans_flag ='A' 
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
                         
    when 'CrmAccountCategory'
      list = Crm::CrmAccountCategory.find_by_sql ["select CAST(( 
                                  select(select id,code, name from crm_account_categories
                                  where  trans_flag ='A' order by name
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
                          
    when 'CrmOpportunity'
      list = Crm::CrmOpportunity.find_by_sql ["select CAST(( 
                                  select(select id,name as code, name from crm_opportunities
                                  where  trans_flag ='A' order by name
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
                         
    when 'DiamondCategory'
      list = Diamond::DiamondCategory.find_by_sql ["select CAST(( 
                                  select(select id,code, name from diamond_categories
                                  where  trans_flag ='A' order by name
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
    when 'DiamondLot'
      list = Diamond::DiamondLot.find_by_sql ["select CAST(( 
                                  select(select id,lot_number as code, description as name from diamond_lots
                                  where  trans_flag ='A' 
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
    when 'DiamondPacket'
      list = Diamond::DiamondPacket.find_by_sql ["select CAST(( 
                                  select(select a.id, a.packet_no as packet_no , b.lot_number as lot_number  from diamond_packets 
                                  as a inner join diamond_lots as b on a.diamond_lot_id = b.id 
                                  where  a.trans_flag ='A' 
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]

    when 'CatalogAttribute'
      list = Item::CatalogAttribute.find_by_sql ["select CAST(( 
                                  select(select id,code, name from catalog_attributes
                                  where  trans_flag ='A' order by name
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
    when 'CatalogAttributeValue'
      list = Item::CatalogAttributeValue.find_by_sql ["select CAST(( 
                                  select(select id,code, name,catalog_attribute_id from catalog_attribute_values
                                  where  trans_flag ='A' order by name
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
    when 'Document'
      list = Admin::Document.find_by_sql ["select CAST(( 
                                  select(select id, code, document_name as name, component_cd from documents
                                  where  trans_flag ='A' 
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
                                    
    when 'Lab'
      list = Vendor::Vendor.find_by_sql ["select CAST(( 
                                  select(select id, code,name from vendors
                                  where  lab_yn = 'Y' and trans_flag='A' order by name
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]

                          
    when 'Role'
      list = Admin::Role.find_by_sql ["select CAST(( 
                                  select(select id, code,role_name as name from roles
                                  where  trans_flag='A' 
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
    when 'Moodule'
      list = Admin::Moodule.find_by_sql ["select CAST(( 
                                  select(select id, code,moodule_name as name from moodules
                                  where  trans_flag='A' 
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
 
    when 'Menu'
      list = Admin::Menu.find_by_sql ["select CAST(( 
                                  select(select id, code,menu_name as name,moodule_id,menu_type from menus
                                  where  trans_flag='A' 
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
                                      
    when 'CatalogOrderStatus'
      list = Setup::Type.find_by_sql ["select CAST(( 
                                  select(select id, value as code, description as name from types
                                  where  type_cd = 'catalog_order_status'
                                     and subtype_cd = 'value' and trans_flag='A'
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]

    when 'MeltingRetailer'
      list = Metal::MeltingRetailer.find_by_sql ["select CAST(( 
                                  select(select id,code, name from melting_retailers
                                  where trans_flag='A'
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]

    when 'WorkbagStages'
      list = Workbag::WorkbagStage.find_by_sql ["select CAST(( 
                                  select(select id,code, name,allow_transfer from workbag_stages
                                  where trans_flag='A' 
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]

    when 'UserStoreAccess'
      #        list = Admin::UserCompany.find(:all,
      #                                      :joins =>"inner join companies on companies.id=user_companies.company_id ",
      #                                      :order => "id",
      #                                      :select => "user_companies.*",
      #                                      :conditions=>["user_id=?",user_id] )   
      #      list = Setup::CompanyStore.find(:all,
      #                                      :order => "code",
      #                                      :select => "id, code, name",
      #                                      :conditions=>["user_id=?",user_id] )  
      list = Setup::Company.find_by_sql ["select CAST(( 
                                  select(select id,company_cd as code,name from companies where companies.trans_flag ='A' and id in (select company_id from user_companies where user_id = ?)
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol",user_id]
    when 'MeltingStageMaster'
      list = Metal::MeltingTransaction.find_by_sql ["select CAST(( 
                                  select(select id,stage_code as code,stage_name as name from melting_stage_master where melting_stage_master.trans_flag ='A'
                                  FOR XML PATH('row'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('rows')) AS varchar(MAX)) as xmlcol"]
        
    else
    end
    if list.nil? 
      list =  Setup::Lookup.new
    end
    list
  end
  
end

