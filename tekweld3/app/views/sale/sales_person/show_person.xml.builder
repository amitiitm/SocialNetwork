xml.instruct! :xml, :version=>"1.0" 

xml.sales_people{
  for sales_person in @people
    xml.sales_person do
      sales_person.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
#      xml.salesperson_equipments{
#        for salesperson_equipments in sales_person.salesperson_equipments
#          xml.salesperson_equipment do
#            salesperson_equipments.attributes.each_pair{ |column_name,column_value|
#              column_value = format_column(column_value)
#              xml.tag!(column_name, column_value)
#            }
#          end
#        end
#      }
      xml.customer_salespeople{
        for customer_salesperson in sales_person.customer_salespeople
          if customer_salesperson.trans_flag=='A'
            xml.customer_salesperson do
              customer_salesperson.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
              xml.customer_name(customer_salesperson.customer.name)
            end
          end
        end
      }
    end
  end
}
