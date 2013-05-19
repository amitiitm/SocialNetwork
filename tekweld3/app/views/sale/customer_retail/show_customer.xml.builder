xml.instruct! :xml, :version=>"1.0" 

xml.customers{
  for customer in @customers
    xml.customer do
      customer.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.shippings{
        for shipping in customer.customer_shippings.active
          xml.shipping do
            shipping.attributes.each_pair{ |column_name,column_value|
              column_value = format_column(column_value)
              xml.tag!(column_name, column_value)
            }
          end
        end
      }
      xml.notes{
        for note in customer.customer_notes
          xml.note do
            note.attributes.each_pair{ |column_name,column_value|
              column_value = format_column(column_value)
              xml.tag!(column_name, column_value)
            }
          end
        end
      }
      xml.customer_salespeople{
        for customer_salesperson in customer.customer_salespeople
          if customer_salesperson.trans_flag=='A'
            xml.customer_salesperson do
              customer_salesperson.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
              xml.salesperson_name(customer_salesperson.salesperson.name)
            end
          end
        end
      }
      xml.customer_relationships{
        for customer_relationship in customer.customer_relationships
          xml.customer_relationship do
            customer_relationship.attributes.each_pair{ |column_name,column_value|
              column_value = format_column(column_value)
              xml.tag!(column_name, column_value)
            }
            customer_code = Customer::Customer.find_by_sql("select code from customers where id = #{customer_relationship.related_customer_id}") if customer_relationship.related_customer_id
            xml.related_customer_code(customer_code.first.code) if customer_code.first
          end
        end
      }
      xml.customer_activities{
      @customer_activities=Customer::Customer.find_by_sql("select sales_invoices.trans_bk,sales_invoices.trans_date,sales_invoices.trans_no,sales_invoice_lines.catalog_item_code,sales_invoice_lines.item_description as catalog_item_description,sales_invoice_lines.item_price as catalog_item_price from sales_invoices inner join customers on sales_invoices.customer_id =customers.id
                                                   inner join sales_invoice_lines on sales_invoice_lines.sales_invoice_id=sales_invoices.id
                                                   where customers.id=#{customer.id}
                                                   union
                                                   select pos_invoices.trans_bk,pos_invoices.trans_date,pos_invoices.trans_no,pos_invoice_lines.catalog_item_code,pos_invoice_lines.item_description as catalog_item_description,pos_invoice_lines.item_price as catalog_item_price from pos_invoices inner join customers on pos_invoices.customer_id =customers.id
                                                   inner join pos_invoice_lines on pos_invoice_lines.pos_invoice_id=pos_invoices.id
                                                   where customers.id=#{customer.id}")  #added by by Praman on 25 july 2011
        for customer_activity in @customer_activities
          xml.customer_activity do
            customer_activity.attributes.each_pair{ |column_name,column_value|
              column_value = format_column(column_value)
              xml.tag!(column_name, column_value)
            }
          end
        end
      }
    end
  end
}
