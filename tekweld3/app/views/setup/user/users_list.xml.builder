xml.instruct! :xml, :version=>"1.0" 
#xml.users{
# for user in @users
#  xml.user do
#   for col in user.attributes
#    column_name = col[0]
#    column_value = col[1]
#  #        column_value = null_to_decimal(column_value) if decimal_fields.include?(column_name) 
#    column_value = date_format(column_value) if column_value.is_a?(Time)
#    xml.tag!(column_name, column_value)
#  end
#end
# end
#}


xml.users{
  for user in @users
  xml.user do
    user.attributes.each_pair{ |column_name,column_value|
      column_value = format_column(column_value)
      xml.tag!(column_name, column_value)
      }   
    case user.login_type 
      when 'V'
        vendor = Vendor::Vendor.find_by_id(user.type_id) if user.type_id
        type_code = vendor.code if vendor
      when 'C'
        customer = Customer::Customer.find_by_id(user.type_id) if user.type_id
        type_code = customer.code if customer
      else
        type_code = 0
    end
    xml.type_code(type_code)
  end
  end
}
