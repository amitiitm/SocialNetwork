xml.instruct! :xml, :version=>"1.0" 
xml.crm_accounts{
  for account in @accounts
    xml.crm_account do
      account.attributes.each_pair{ |column_name,column_value|
        xml.tag!(column_name, column_value)
      }
    end
  end
}
