xml.instruct! :xml, :version=>"1.0"

xml.params{
  xml.payment_profiles{
    for payment_profile in @customer.customer_payment_profiles.active
      xml.payment_profile do
        payment_profile.attributes.each_pair{ |column_name,column_value|
          column_value = format_column(column_value)
          xml.tag!(column_name, column_value)
        }
      end
    end
    xml.payment_profile{
      xml.customer_profile_code("")
      xml.customer_payment_profile_code("")
      xml.payment_method("")
      xml.card_number("")
      xml.expiration("")
    }
  }
    xml.result(@result)
}
