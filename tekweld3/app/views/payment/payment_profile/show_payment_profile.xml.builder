xml.instruct! :xml, :version=>"1.0"
xml.customer_payment_profiles{
  for payment_profile in @payment_profiles
    xml.customer_payment_profile do
      payment_profile.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.message(@message)
    end
  end
}