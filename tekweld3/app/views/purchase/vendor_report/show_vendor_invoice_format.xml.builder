xml.instruct! :xml, :version=>"1.0" 
xml.invoices{
   for vendor_invoice in @invoices
    xml.invoice do
       vendor_invoice.attributes.each_pair{ |column_name,column_value|
       column_value = format_column(column_value)
       column_value = sprintf( "%0.02f", column_value) if ((column_name =~ /(.*)amt(.*)/ ) and column_value)     
       column_value = sprintf( "%0.0f", column_value) if ((column_name =~ /(.*)qty(.*)/ ) and column_value)
       xml.tag!(column_name, column_value)  if column_name != 'company_logo_file'            
       if (column_name =~ /(.*)company_logo_file(.*)/ )
       schemaname=session[:schema]
       filename=column_value 
       if filename.nil? then filename = '' end
       if filename.strip == '' then filename = 'blank.jpg' end
       if File.exist?("#{Dir.getwd}/public/images/#{schemaname}/#{filename}") == true
         filename = "http://#{request.env['HTTP_HOST']}/images/#{schemaname}/#{filename}"
       else
         filename = "http://#{request.env['HTTP_HOST']}/images/#{schemaname}/blank.jpg"
       end
       xml.company_logo_file(filename)
       end
      }
    xml.invoice_lines{
      for vendor_invoice_line in @invoice_lines
        xml.invoice_line do
          vendor_invoice_line.attributes.each_pair{ |column_name,column_value|
          column_value = format_column(column_value)
          column_value = sprintf( "%0.02f", column_value) if ((column_name =~ /(.*)amt(.*)/ ) and column_value)     
          xml.tag!(column_name, column_value)
          }
        end
      end
      }
    end
 end
}