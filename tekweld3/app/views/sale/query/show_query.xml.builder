xml.instruct! :xml, :version=>"1.0"

xml.queries{
  for query in @queries
    xml.query do
      query.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value) if column_name != 'date_added'
        xml.tag!(column_name, column_value) if column_name != 'date_added'
        xml.date_added(column_value.strftime('%Y-%m-%d %H:%M:%S')) if column_name == 'date_added'
      }
      xml.trans_type(query.sales_order.trans_type)
      xml.ship_date(query.sales_order.ship_date)
      xml.user_name(query.user.first_name + ' ' + query.user.last_name)
    end
  end
}