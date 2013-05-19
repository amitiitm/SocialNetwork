xml.instruct! :xml, :version=>"1.0" 
xml.gl_setups{
  for gl_setup in @gl_setups
    xml.gl_setup do
      gl_setup.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.gl_setup_items{
        for gl_setup_item in gl_setup.gl_setup_items
          if gl_setup_item.trans_flag == 'A'
            xml.gl_setup_item do
              gl_setup_item.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }
              xml.item_type_desc('Assembly') if gl_setup_item.item_type=='A'
              xml.item_type_desc('Inventory') if gl_setup_item.item_type=='I'
              xml.item_type_desc('Diamond') if gl_setup_item.item_type=='D'
              xml.sales_account_name(gl_setup_item.sales_account.name) if gl_setup_item.sales_account
              xml.purchase_account_name(gl_setup_item.purchase_account.name) if gl_setup_item.purchase_account

            end
          end
        end
      }
    end
  end
}
