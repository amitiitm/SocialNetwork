class Setup::CheckValidityCrud
  include General
  
  def self.get_table_name(lookupname,column_name,value,filter_key_name,filter_key_value)
    if (filter_key_name.length != 0 and filter_key_value.length != 0)
      condition = " and #{filter_key_name} = #{filter_key_value}"
    else
      condition = ""
    end
    case lookupname
    when 'User'
      tablename = 'users'
    when 'CompanyStore'
      tablename = 'companies'
    when 'AccountPeriod'
      tablename = 'account_periods'
    when 'GlCategory'
      tablename = 'gl_categories'
    when 'GLAccount'
      tablename='gl_accounts'
    when 'GLBankAccount'
      list = GeneralLedger::GlAccount.find(:all,
        :conditions => ["acct_flag = 'B' and trans_flag='A' and #{column_name} = ?", value],
        :select => "id, code, name")                
    when 'Bank'
      tablename = 'banks'
    when 'CustomerCategory'
      tablename = 'customer_categories'
    when 'Customer'
      list = Customer::Customer.find(:all, 
        :select => " customers.* ",
        :conditions=>["customer_type = 'W' and trans_flag='A' and #{column_name} = ? #{condition}",value])
      ## newly added on 29 july 2011 by amit
    when 'RetailCustomer'
      list = Customer::Customer.find(:all, 
        :select => " customers.* ",
        :conditions=>["customer_type = 'R' and trans_flag='A' and #{column_name} = ? #{condition}",value])
    when 'CustomerShipping'
      list = Customer::CustomerShipping.find(:all,
        :select => " customer_shippings.* ",
        :conditions => [" customers.customer_type = 'W' and customer_shippings.trans_flag ='A'  and customer_shippings.#{column_name} = ? #{condition}",value],
        :joins=>"inner join customers on customers.id = customer_shippings.customer_id")
      
    when 'RetailCustomerShipping'
      list = Customer::CustomerShipping.find(:all,
        :select => " customer_shippings.* ",
        :conditions => [" customers.customer_type = 'R' and customer_shippings.trans_flag ='A'  and customer_shippings.#{column_name} = ? #{condition}",value],
        :joins=>"inner join customers on customers.id = customer_shippings.customer_id")
    when 'CustomerContact'
      list = Customer::CustomerContact.find(:all, 
        :select => " customer_contacts.*,(customer_contacts.first_name +' '+ customer_contacts.last_name) as contact_name ",
        :conditions=>["trans_flag='A' and (customer_contacts.first_name +' '+ customer_contacts.last_name) = ? #{condition}",value])
    when 'Salesperson'
      tablename = 'salespeople'
    when 'ExternalSalesPerson'
      tablename = 'salespeople'
    when 'Purchaseperson'
      tablename = 'purchasepeople'
    when 'Labor'
      tablename = 'labors'
    when 'VendorCategory'
      tablename = 'vendor_categories'
    when 'Vendor'
      tablename = 'vendors'
    when 'Term'
      tablename = 'terms'
    when 'Item'
      tablename = 'catalog_items'
    when 'AccessoriesItem'
      tablename = 'catalog_items'
    when 'ItemSpecificAccessoriesItem'
      list = Item::CatalogItem.find_by_sql ["select ci.id, store_code, name,sale_description as description,unit
                                             from catalog_item_accessories cia
                                             inner join catalog_items ci on ci.id = cia.accessory_item_id
                                             where cia.trans_flag ='A' and item_type = 'C' and store_code = ?  #{condition}
                                             order by store_code",value]
    when 'ImprintType'
      list = Item::CatalogItemAttributesValue.find_by_sql ["select cav.id,cav.code,cav.name from catalog_attribute_values cav
                                                            inner join catalog_attributes ca on ca.id = cav.catalog_attribute_id
                                                            where ca.code = '#{CATALOG_ATTRIBUTE_CODE}' and cav.code = ?  #{condition}
                                                            order by cav.code",value]
      #      tablename = 'catalog_item_accessories'
    when 'AssembleItem'
      tablename = 'catalog_items'
    when 'InventoryItem'
      tablename = 'catalog_items'
    when 'NonInventoryItem'
      tablename = 'catalog_items'
    when 'SetupItem'
      tablename = 'catalog_items'
    when 'InventorySetupItem'
      tablename = 'catalog_items'
    when 'ItemGroup'
      tablename = 'catalog_groups'
    when 'ItemCategory'
      tablename = 'catalog_item_categories'
    when 'Shipping'
      tablename = 'shippings'
    when 'Location'
      tablename = 'locations'
    when 'CrmAccount'
      tablename = 'crm_accounts'
    when 'CrmContact'
      tablename = 'crm_accounts'
    when 'CrmTask'
      tablename = 'crm_tasks'
    when 'CrmAccountCategory'
      tablename = 'crm_account_categories'
    when 'CrmOpportunity'
      tablename = 'crm_opportunities'
    when 'DiamondCategory'
      tablename = 'diamond_categories'
    when 'DiamondLot'
      tablename = 'diamond_lots'
    when 'DiamondPacket'
      tablename = 'diamond_packets'
    when 'CatalogAttribute'
      tablename = 'catalog_attributes'
    when 'CatalogAttributeValue'
      tablename = 'catalog_attribute_values'
    when 'Document'
      tablename = 'documents'                      
    when 'Lab'
      list = Vendor::Vendor.find(:all,
        :select => "id, code, name",
        :conditions =>[ "lab_yn = 'Y' and trans_flag='A' and #{column_name} = ?",value]
      )
                          
    when 'Role'
      tablename = 'roles'
    when 'Moodule'
      tablename = 'moodules'
    when 'Menu'
      tablename = 'menus'
    when 'SubMenu'
      tablename = 'menus'
    when 'CatalogOrderStatus'
      list = Setup::Type.find(:all,
        :select => "id, value as code, description as name",
        :conditions =>[ " type_cd = 'catalog_order_status and #{column_name} like ?
                         and subtype_cd = 'value' and trans_flag='A'",'%'+value+'%']
      )
    when 'MeltingRetailer'
      tablename = 'melting_retailers'
    when 'WorkbagStages'
      tablename = 'workbag_stages'
    when 'UserStoreAccess'
      list = Setup::Company.find_by_sql ["select id,company_cd ,name from companies where companies.trans_flag ='A' and id in (select company_id from user_companies) and #{column_name} = ?",value]
    when 'MeltingStageMaster'
      tablename = 'melting_stage_master'
    when 'CustomerPaymentProfile'
      tablename = 'customer_payment_profiles'
    when 'CustomerSpecificShippings'
      tablename = 'customer_shippings'
    when 'CustomerWholesale'
      list = Customer::Customer.find(:all,
        :select => " customers.* ",
        :conditions=>["customer_type = 'W' and trans_flag='A' and #{column_name} = ? #{condition}",value])
    when 'OrderStatus' ## test it changes made by nitin
      #list = Sales::SalesOrder.find_by_sql ["select stage_code from order_master_stages where main_stage_flag = 'Y'and #{column_name} = ? ",value]
      list = Sales::SalesOrder.find_by_sql ["select stage_code from order_master_stages where main_stage_flag = 'Y'and #{column_name} = ? ",value]
    when 'DiscountCoupons'
      list = Setup::DiscountCoupon.find_by_sql [" SELECT	id, coupon_code as code, discount_reason as name
                                                  FROM discount_coupons
                                                  WHERE	trans_flag ='A' and approval_flag = 'Y' and
                                                  ((no_of_uses - no_of_used) <> 0) and  coupon_code =? #{condition}",value
      ]
    when 'ServiceCharges'
      list = Item::CatalogItem.find_by_sql  [" SELECT	id, store_code, name
                                                              FROM catalog_items
                                                              WHERE	trans_flag ='A' and item_type = 'S' and store_code=?  #{condition}",value]
    end
    return tablename,list
  end    
  
  def self.get_limited_lookup(lookupname,value,filter_key_name,filter_key_value)
    if (filter_key_name.length != 0 and filter_key_value.length != 0)
      condition = " and #{filter_key_name} = #{filter_key_value}"
    else
      condition = ""
    end
    case lookupname     
      ## newly added on 29 july 2011 by amit
    when 'RetailCustomer'
      list = Customer::Customer.find(:all, 
        :select => "id, code, name,phone1 as phone,email",
        :conditions=>["customer_type = 'R' and trans_flag='A' and ( code like ? or name like ? or phone1 like ? or email like ?) ",'%'+value+'%','%'+value+'%','%'+value+'%','%'+value+'%' ])
      
    when 'RetailCustomerShipping'
      list = Customer::CustomerShipping.find(:all,
        :order => "name",
        :select => "customer_shippings.id, customer_shippings.code, customer_shippings.name, customer_shippings.customer_id",
        :conditions => [" customers.customer_type = 'R' and customer_shippings.trans_flag ='A'  and ( customer_shippings.code like ? or customer_shippings.name like ? ) #{condition}",'%'+value+'%','%'+value+'%' ],
        :joins=>"inner join customers on customers.id = customer_shippings.customer_id")
      
                                    
    when 'Labor'
      list = Inventory::Labor.find( :all, 
        :select => "id, code ,code as name",
        :conditions => ["trans_flag ='A' and ( code like ? ) #{condition}",'%'+value+'%'])
        
    when 'Location'
      list = Item::Location.find(:all, 
        :select => "id, code, name",
        :conditions =>["trans_flag ='A' and ( code like ? or name like ? ) #{condition}",'%'+value+'%','%'+value+'%'])

      ######## Tekweld Services for limited lookups.
    when 'UserStoreAccess'
      list = Setup::Company.find_by_sql ["SELECT CAST((SELECT(select id,company_cd ,name from companies where companies.trans_flag ='A' and id in (select company_id from user_companies) and ( company_cd like ? or name like ? ) #{condition} FOR XML PATH('row'), ELEMENTS XSINIL, TYPE) FOR XML PATH('rows')) AS xml)AS xmlcol",'%'+value+'%','%'+value+'%']
    when 'Customer'
      list = Customer::Customer.find_by_sql ["SELECT CAST((
                                                      SELECT (
                                                              SELECT	id, code, name,phone1 as phone,email,city,contact1,contact2,contact3,contact4
                                                              FROM customers
                                                              WHERE	trans_flag ='A' and customer_type = 'W' and ( code like ? or name like ? or phone1 like ? or email like ? or city like ?) #{condition} order by name
                                                              FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                      AS xml) AS xmlcol",'%'+value+'%','%'+value+'%','%'+value+'%','%'+value+'%','%'+value+'%' ]
    when 'CustomerContact'
      list = Customer::CustomerContact.find_by_sql ["SELECT CAST((
                                                      SELECT (
                                                              SELECT	customer_contacts.id,(customer_contacts.first_name + ' ' + customer_contacts.last_name) as contact_name,customer_contacts.first_name,customer_contacts.last_name,
                                                                      customer_contacts.city,customer_contacts.state,customer_contacts.zip,customer_contacts.country,customer_contacts.email,customer_contacts.department
                                                              FROM customer_contacts
                                                              WHERE	customer_contacts.trans_flag='A' and ( customer_contacts.first_name like ? or customer_contacts.last_name like ? or customer_contacts.city like ? or customer_contacts.state like ? or customer_contacts.zip like ? or customer_contacts.country like ? or (customer_contacts.first_name +' '+ customer_contacts.last_name) like ?) #{condition}
                                                              FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                      AS xml) AS xmlcol",'%'+value+'%','%'+value+'%','%'+value+'%','%'+value+'%','%'+value+'%','%'+value+'%','%'+value+'%']
    when 'InventoryItem'
      list = Item::CatalogItem.find_by_sql ["SELECT CAST((
                                                      SELECT (
                                                              SELECT	id, store_code, name
                                                              FROM catalog_items
                                                              WHERE	trans_flag ='A' and item_type = 'I' and ( store_code like ? or name like ? ) #{condition} order by store_code
                                                              FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                      AS xml) AS xmlcol",'%'+value+'%','%'+value+'%']
    when 'NonInventoryItem'
      list = Item::CatalogItem.find_by_sql ["SELECT CAST((
                                                      SELECT (
                                                              SELECT	id, store_code, name
                                                              FROM catalog_items
                                                              WHERE catalog_item_category_code <> 'OPTIONLINKED' AND trans_flag ='A' and item_type = 'I' and ( store_code like ? or name like ? ) #{condition} order by store_code
                                                              FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                      AS xml) AS xmlcol",'%'+value+'%','%'+value+'%']
    when 'AccessoriesItem'
      list = Item::CatalogItem.find_by_sql ["SELECT CAST((
                                                      SELECT (
                                                              SELECT	id, store_code, name,cost,sale_description as description,unit
                                                              FROM catalog_items
                                                              WHERE	trans_flag ='A' and item_type = 'C' and ( store_code like ? or name like ? ) #{condition} order by store_code
                                                              FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                      AS xml) AS xmlcol",'%'+value+'%','%'+value+'%']
    when 'ItemSpecificAccessoriesItem'
      list = Item::CatalogItem.find_by_sql ["SELECT CAST((
                                                      SELECT (
                                                               select ci.id, store_code, name,sale_description as description,unit 
                                                               from catalog_item_accessories cia
                                                               inner join catalog_items ci on ci.id = cia.accessory_item_id
                                                               where cia.trans_flag ='A' and item_type = 'C' and ( store_code like ? or name like ? ) #{condition}
                                                               order by store_code
                                                              FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                      AS xml) AS xmlcol",'%'+value+'%','%'+value+'%']

    when 'AssembleItem'
      list = Item::CatalogItem.find_by_sql ["SELECT CAST((
                                                      SELECT (
                                                              SELECT	id, store_code, name,cost,sale_description as description,unit
                                                              FROM catalog_items
                                                              WHERE	trans_flag ='A' and item_type = 'A' and ( store_code like ? or name like ? ) #{condition} order by store_code
                                                              FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                      AS xml) AS xmlcol",'%'+value+'%','%'+value+'%']
    when 'SetupItem'
      list = Item::CatalogItem.find_by_sql ["SELECT CAST((
                                                      SELECT (
                                                              SELECT	id, store_code, name
                                                              FROM catalog_items
                                                              WHERE	trans_flag ='A' and item_type = 'S' and ( store_code like ? or name like ? ) #{condition} order by store_code
                                                              FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                      AS xml) AS xmlcol",'%'+value+'%','%'+value+'%']
    when 'InventorySetupItem'
      list = Item::CatalogItem.find_by_sql ["SELECT CAST((
                                                      SELECT (
                                                              SELECT	id, store_code, name
                                                              FROM catalog_items
                                                              WHERE	trans_flag ='A' and item_type in ('I','S') and ( store_code like ? or name like ? ) #{condition} order by store_code
                                                              FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                      AS xml) AS xmlcol",'%'+value+'%','%'+value+'%']
    when 'Vendor'
      list = Vendor::Vendor.find_by_sql ["SELECT CAST((
                                                      SELECT (
                                                              SELECT	id, code, name
                                                              FROM vendors
                                                              WHERE	trans_flag ='A'  and ( code like ? or name like ? ) #{condition}
                                                              FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                      AS xml) AS xmlcol",'%'+value+'%','%'+value+'%']
    when 'VendorCategory'
      list = Vendor::VendorCategory.find_by_sql(["SELECT CAST((
                                                              SELECT (
                                                                      SELECT	id, code, name
                                                                      FROM vendor_categories
                                                                      WHERE	trans_flag ='A'  and ( code like ? or name like ? ) #{condition}
                                                                      ORDER BY name
                                                                      FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                                      )
                                                              FOR XML PATH('rows')
                                                              )
                                                              AS XML) AS xmlcol",'%'+value+'%','%'+value+'%'])
    when 'Role'
      list = Admin::Role.find_by_sql ["SELECT CAST((
                                                      SELECT (
                                                              SELECT	id, code,role_name as name
                                                              FROM roles
                                                              WHERE	trans_flag ='A'  and ( code like ? or role_name like ? ) #{condition}
                                                              FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                      AS xml) AS xmlcol",'%'+value+'%','%'+value+'%']
    when 'Moodule'
      list = Admin::Moodule.find_by_sql ["SELECT CAST((
                                                      SELECT (
                                                              SELECT	id, code,moodule_name
                                                              FROM moodules
                                                              WHERE	trans_flag ='A'  and ( code like ? or moodule_name like ? ) #{condition}
                                                              FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                      AS xml) AS xmlcol",'%'+value+'%','%'+value+'%']

    when 'Menu'
      list = Admin::Menu.find_by_sql(["SELECT CAST((
                                                    SELECT (
                                                            SELECT	id, code, menu_name as name
                                                            FROM menus
                                                            WHERE	trans_flag ='A' and menu_type = 'M' and ( code like ? or menu_name like ? ) #{condition}
                                                            FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                            )
                                                    FOR XML PATH('rows')
                                                    )
                                                    AS XML) AS xmlcol",'%'+value+'%','%'+value+'%'])
    when 'SubMenu'
      list = Admin::Menu.find_by_sql(["SELECT CAST((
                                                    SELECT (
                                                            SELECT	id, code, menu_name as name
                                                            FROM menus
                                                            WHERE	trans_flag ='A' and menu_type = 'S' and ( code like ? or menu_name like ? ) #{condition}
                                                            FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                            )
                                                    FOR XML PATH('rows')
                                                    )
                                                    AS XML) AS xmlcol",'%'+value+'%','%'+value+'%'])
    when 'Item'
      list = Item::CatalogItem.find_by_sql ["SELECT CAST((
                                                      SELECT (
                                                              SELECT	id, store_code as code, name
                                                              FROM catalog_items
                                                              WHERE	trans_flag ='A'  and ( store_code like ? or name like ? ) #{condition} order by store_code
                                                              FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                      AS xml) AS xmlcol",'%'+value+'%','%'+value+'%']


    when 'ItemGroup'
      list = Item::CatalogGroup.find_by_sql ["SELECT CAST((
                                                      SELECT (
                                                              SELECT	id, code, name
                                                              FROM catalog_groups
                                                              WHERE	trans_flag ='A'  and ( code like ? or name like ? ) #{condition}
                                                              FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                      AS xml) AS xmlcol",'%'+value+'%','%'+value+'%']


    when 'ItemCategory'
      list = Item::CatalogItemCategory.find_by_sql ["SELECT CAST((
                                                      SELECT (
                                                              SELECT	id, code, name
                                                              FROM catalog_item_categories
                                                              WHERE	trans_flag ='A'  and ( code like ? or name like ? ) #{condition} order by name
                                                              FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                      AS xml) AS xmlcol",'%'+value+'%','%'+value+'%']
    when 'Term'
      list = Setup::Term.find_by_sql ["SELECT CAST((
                                                      SELECT (
                                                              SELECT	id, code, name
                                                              FROM terms
                                                              WHERE	trans_flag ='A'  and ( code like ? or name like ? ) #{condition}
                                                              FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                      AS xml) AS xmlcol",'%'+value+'%','%'+value+'%']
    when 'Document'
      list = Admin::Document.find_by_sql ["SELECT CAST((
                                                      SELECT (
                                                              SELECT	id, code, document_name, component_cd
                                                              FROM documents
                                                              WHERE	trans_flag ='A'  and ( code like ? or document_name like ? ) #{condition}
                                                              FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                      AS xml) AS xmlcol",'%'+value+'%','%'+value+'%']
    when 'CatalogAttribute'
      list = Item::CatalogAttribute.find_by_sql ["SELECT CAST((
                                                      SELECT (
                                                              SELECT	id, code, name
                                                              FROM catalog_attributes
                                                              WHERE	trans_flag ='A'  and ( code like ? or name like ? ) #{condition}
                                                              FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                      AS xml) AS xmlcol",'%'+value+'%','%'+value+'%']
    when 'Salesperson'
      list = Customer::Salesperson.find_by_sql ["SELECT CAST((
                                                      SELECT (
                                                              SELECT	id, code, name
                                                              FROM salespeople
                                                              WHERE	trans_flag ='A' and category = 'Internal'  and ( code like ? or name like ? ) #{condition} order by name
                                                              FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                      AS xml) AS xmlcol",'%'+value+'%','%'+value+'%']

    when 'ExternalSalesPerson'
      list = Customer::Salesperson.find_by_sql ["SELECT CAST((
                                                      SELECT (
                                                              SELECT	id, code, name
                                                              FROM salespeople
                                                              WHERE	trans_flag ='A' and category = 'External' and ( code like ? or name like ? ) #{condition} order by name
                                                              FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                      AS xml) AS xmlcol",'%'+value+'%','%'+value+'%']

    when 'Shipping'
      list = Setup::Shipping.find_by_sql ["SELECT CAST((
                                                      SELECT (
                                                              SELECT	id, code, name
                                                              FROM shippings
                                                              WHERE	trans_flag ='A' and ( code like ? or name like ? ) #{condition} order by name
                                                              FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                      AS xml) AS xmlcol",'%'+value+'%','%'+value+'%']
    when 'User'
      list = Admin::User.find_by_sql ["SELECT CAST((
                                                      SELECT (
                                                              SELECT	id, user_cd, first_name
                                                              FROM users
                                                              WHERE	trans_flag ='A' and ( user_cd like ? or first_name like ? ) #{condition} order by first_name
                                                              FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                      AS xml) AS xmlcol",'%'+value+'%','%'+value+'%']


    when 'CustomerCategory'
      list = Customer::CustomerCategory.find_by_sql ["SELECT CAST((
                                                      SELECT (
                                                              SELECT	id, code, name
                                                              FROM customer_categories
                                                              WHERE	trans_flag ='A' and ( code like ? or name like ? ) #{condition}
                                                              FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                      AS xml) AS xmlcol",'%'+value+'%','%'+value+'%']
    when 'CompanyStore'
      list =   Setup::Company.find_by_sql(["SELECT CAST((
                                                      SELECT (
                                                              SELECT	id, company_cd , name
                                                              FROM companies
                                                              WHERE	trans_flag ='A' and ( company_cd like ? or name like ? ) #{condition}
                                                              ORDER BY company_cd
                                                              FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                  AS XML) AS xmlcol",'%'+value+'%','%'+value+'%'])
    when 'CustomerPaymentProfile'
      list =   Payment::CustomerPaymentProfile.find_by_sql(["SELECT CAST((
                                                      SELECT (
                                                              SELECT	*
                                                              FROM customer_payment_profiles
                                                              WHERE	trans_flag ='A' and (customer_profile_code like ? or customer_payment_profile_code like ? or card_number like ? ) #{condition}                                                             
                                                              FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                  AS XML) AS xmlcol",'%'+value+'%','%'+value+'%','%'+value+'%'])
    when 'CatalogAttributeValue'
      list = Item::CatalogAttributeValue.find_by_sql(["SELECT CAST((
                                                                    SELECT (
                                                                            SELECT	id, code, name, catalog_attribute_id
                                                                            FROM catalog_attribute_values
                                                                            WHERE	trans_flag ='A'  and ( code like ? or name like ? ) #{condition}
                                                                            FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                                            )
                                                                    FOR XML PATH('rows')
                                                                    )
                                                                    AS XML) AS xmlcol",'%'+value+'%','%'+value+'%'])
    when 'AccountPeriod'
      list = Setup::AccountPeriod.find_by_sql(["SELECT CAST((
                                                            SELECT (
                                                                    SELECT	id, code, description as name
                                                                    FROM account_periods
                                                                    WHERE	trans_flag ='A' and gl='O' and ( code like ? or description like ? ) #{condition}
                                                                    FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                                    )
                                                            FOR XML PATH('rows')
                                                            )
                                                            AS XML) AS xmlcol",'%'+value+'%','%'+value+'%'])
    when 'GlCategory'
      list = GeneralLedger::GlCategory.find_by_sql(["SELECT CAST((
                                                                  SELECT (
                                                                          SELECT	id, code, name
                                                                          FROM gl_categories
                                                                          WHERE	trans_flag ='A' and ( code like ? or name like ? ) #{condition}
                                                                          FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                                          )
                                                                  FOR XML PATH('rows')
                                                                  )
                                                                  AS XML) AS xmlcol",'%'+value+'%','%'+value+'%'])
    when 'GLAccount'
      list = GeneralLedger::GlAccount.find_by_sql(["SELECT CAST((
                                                                SELECT (
                                                                        SELECT	id, code, name
                                                                        FROM gl_accounts
                                                                        WHERE	acct_flag != 'B' and trans_flag='A' and ( code like ? or name like ? ) #{condition}
                                                                        FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                                        )
                                                                FOR XML PATH('rows')
                                                                )
                                                                AS XML) AS xmlcol",'%'+value+'%','%'+value+'%'])
    when 'GLBankAccount'
      list = GeneralLedger::GlAccount.find_by_sql(["SELECT CAST((
                                                                SELECT (
                                                                        SELECT	id, code, name
                                                                        FROM gl_accounts
                                                                        WHERE	acct_flag = 'B' and trans_flag='A' and ( code like ? or name like ? ) #{condition}
                                                                        FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                                        )
                                                                FOR XML PATH('rows')
                                                                )
                                                                AS XML) AS xmlcol",'%'+value+'%','%'+value+'%'])

    when 'Bank'
      list = GeneralLedger::Bank.find_by_sql(["SELECT CAST((
                                                            SELECT (
                                                                    SELECT	id, code, name
                                                                    FROM banks
                                                                    WHERE	trans_flag ='A'  and ( code like ? or name like ? ) #{condition}
                                                                    FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                                    )
                                                            FOR XML PATH('rows')
                                                            )
                                                            AS XML) AS xmlcol",'%'+value+'%','%'+value+'%'])

    when 'CustomerShipping'
      list = Customer::CustomerShipping.find_by_sql(["SELECT CAST((
                                                                  SELECT (
                                                                          SELECT	customer_shippings.id, customer_shippings.code, customer_shippings.name, customer_shippings.customer_id
                                                                          FROM customer_shippings
                                                                          INNER JOIN customers on customers.id = customer_shippings.customer_id
                                                                          WHERE	customers.customer_type = 'W' and customer_shippings.trans_flag ='A'  and ( customer_shippings.code like ? or customer_shippings.name like ? ) #{condition}
                                                                          ORDER by name
                                                                          FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                                          )
                                                                  FOR XML PATH('rows')
                                                                  )
                                                                  AS XML) AS xmlcol",'%'+value+'%','%'+value+'%'])
    when 'Purchaseperson'
      list = Vendor::Purchaseperson.find_by_sql(["SELECT CAST((
                                                              SELECT (
                                                                      SELECT	id, code, name
                                                                      FROM purchasepeople
                                                                      WHERE	trans_flag ='A'  and ( code like ? or name like ? ) #{condition}
                                                                      ORDER BY name
                                                                      FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                                      )
                                                              FOR XML PATH('rows')
                                                              )
                                                              AS XML) AS xmlcol",'%'+value+'%','%'+value+'%'])
    when 'CrmAccount'
      list = Crm::CrmAccount.find_by_sql(["SELECT CAST((
                                                        SELECT (
                                                                SELECT	id, account_number, name
                                                                FROM crm_accounts
                                                                WHERE	trans_flag ='A' and ( account_number like ? or name like ? ) #{condition}
                                                                FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                                )
                                                FOR XML PATH('rows')
                                                )
                                                AS XML) AS xmlcol",'%'+value+'%','%'+value+'%'])
    when 'CrmContact'
      list = Crm::CrmContact.find_by_sql(["SELECT CAST((
                                                        SELECT (
                                                                SELECT	id, first_name,last_name
                                                                FROM crm_contacts
                                                                WHERE	trans_flag ='A' and ( first_name like ? or last_name like ? ) #{condition}
                                                                FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                                )
                                                        FOR XML PATH('rows')
                                                        )
                                                        AS XML) AS xmlcol",'%'+value+'%','%'+value+'%'])

    when 'CrmTask'
      list = Crm::CrmTask.find_by_sql(["SELECT CAST((
                                                    SELECT (
                                                            SELECT	id, crm_account_id
                                                            FROM crm_tasks
                                                            WHERE	trans_flag ='A' and crm_account_id like ?
                                                            FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                            )
                                                    FOR XML PATH('rows')
                                                    )
                                                    AS XML) AS xmlcol",'%'+value+'%','%'+value+'%'])

    when 'CrmAccountCategory'
      list = Crm::CrmAccountCategory.find_by_sql(["SELECT CAST((
                                                                SELECT (
                                                                        SELECT	id, code, name
                                                                        FROM crm_account_categories
                                                                        WHERE	trans_flag ='A'  and ( code like ? or name like ? ) #{condition}
                                                                        FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                                        )
                                                                FOR XML PATH('rows')
                                                                )
                                                                AS XML) AS xmlcol",'%'+value+'%','%'+value+'%'])

    when 'CrmOpportunity'
      list = Crm::CrmOpportunity.find_by_sql(["SELECT CAST((
                                                            SELECT (
                                                                    SELECT	id, id as code, name
                                                                    FROM crm_opportunities
                                                                    WHERE	trans_flag ='A'  and ( id like ? or name like ? ) #{condition}
                                                                    FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                                    )
                                                            FOR XML PATH('rows')
                                                            )
                                                            AS XML) AS xmlcol",'%'+value+'%','%'+value+'%'])
    when 'CustomerSpecificShippings'
      list = Customer::CustomerShipping.find_by_sql(["SELECT CAST((
                                                            SELECT (
                                                                    select * from customer_shippings
                                                                    WHERE	trans_flag ='A'  and ( code like ? or name like ? or address1 like ? or city like ? or state like ? or zip like ? or country like ?) #{condition}
                                                                    FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                                    )
                                                            FOR XML PATH('rows')
                                                            )
                                                            AS XML) AS xmlcol",'%'+value+'%','%'+value+'%','%'+value+'%','%'+value+'%','%'+value+'%','%'+value+'%','%'+value+'%'])

    when 'CustomerWholesale'
      list = Customer::Customer.find_by_sql(["SELECT CAST((
                                                          SELECT (
                                                                  SELECT	id, code, name,phone1 as phone,email
                                                                  FROM customers
                                                                  WHERE	customer_type = 'W' and trans_flag='A' and ( code like ? or name like ? or phone1 like ? or email like ?)
                                                                  FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                                  )
                                                          FOR XML PATH('rows')
                                                          )
                                                          AS XML) AS xmlcol",'%'+value+'%','%'+value+'%','%'+value+'%','%'+value+'%'])
    when 'OrderStatus' ## test it changes made by nitin
      seq_no = Sales::SalesOrder.find_by_sql("select max(sequence_no) as sequence_no from order_master_stages where stage_code in (#{filter_key_value})")
      list =Sales::SalesOrder.find_by_sql ["SELECT CAST((
                                                      SELECT (
                                                     select id,stage_code,stage_name from order_master_stages where main_stage_flag = 'Y' AND sequence_no < #{seq_no[0].sequence_no}
                                                     FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                      AS xml) AS xmlcol",'%'+value+'%','%'+value+'%']
    when 'ImprintType'
      list = Item::CatalogItemAttributesValue.find_by_sql(["SELECT CAST((
                                                          SELECT (
                                                                  SELECT	cav.id,cav.code,cav.name
                                                                  FROM catalog_attribute_values cav
                                                                  inner join catalog_attributes ca on ca.id = cav.catalog_attribute_id
                                                                  WHERE	ca.code = '#{CATALOG_ATTRIBUTE_CODE}' and ca.trans_flag='A' and ( cav.code like ? or cav.name like ?)
                                                                  FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                                  )
                                                          FOR XML PATH('rows')
                                                          )
                                                          AS XML) AS xmlcol",'%'+value+'%','%'+value+'%'])
    
    when 'ServiceCharges'
      list = Item::CatalogItem.find_by_sql  ["SELECT CAST((
                                                      SELECT (
                                                              SELECT	id, store_code as code,store_code, name
                                                              FROM catalog_items
                                                              WHERE	trans_flag ='A' and item_type = 'S' and store_code like ?  #{condition} order by store_code
                                                              FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                      AS xml) AS xmlcol",'%'+value+'%']
    when 'DiscountCoupons'
      list = Setup::DiscountCoupon.find_by_sql ["SELECT CAST((
                                                      SELECT (
                                                              SELECT	id, coupon_code as code, coupon_code, discount_reason as name
                                                              FROM discount_coupons
                                                              WHERE	trans_flag ='A' and ((no_of_uses - no_of_used) <> 0) and
                                                              approval_flag = 'Y' and
                                                              coupon_code like ? and
                                                              (CONVERT(date,GETDATE(),101) between CONVERT(date,from_date,101) and CONVERT(date,to_date,101)) #{condition}
                                                               order by coupon_code
                                                              FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                      AS xml) AS xmlcol",'%'+value+'%']
    when 'SubOrders'
      list = Sales::SalesOrder.find_by_sql ["SELECT CAST((
                                                      SELECT (
                                                              SELECT	*
                                                              FROM sales_orders
                                                              WHERE	trans_flag ='A'  and (trans_no like ? or customer_code like ?)
                                                              #{condition}
                                                              order by trans_no
                                                              FOR XML PATH('row'),ELEMENTS XSINIL,TYPE
                                                              )
                                                      FOR XML PATH('rows')
                                                      )
                                                      AS xml) AS xmlcol",'%'+value+'%','%'+value+'%']
    else
    end
    if list.nil?
      list =  Setup::Lookup.new
    end
    list
  end
end
