xml.instruct! :xml, :version=>"1.0" 
xml.purchase_indents{
  for purchase_indent in @purchase_indent
    xml.purchase_indent do
      purchase_indent.attributes.each_pair{ |column_name,column_value|
        column_value = format_column(column_value)
        xml.tag!(column_name, column_value)
      }
      xml.purchase_indent_lines{
        for purchase_indent_line in purchase_indent.purchase_indent_lines
          if purchase_indent_line.trans_flag == 'A'
            xml.purchase_indent_line do
              purchase_indent_line.attributes.each_pair{ |column_name,column_value|
                column_value = format_column(column_value)
                xml.tag!(column_name, column_value)
              }    
              if purchase_indent_line.catalog_item              
                xml.packet_require_yn(purchase_indent_line.catalog_item.packet_require_yn)
                xml.image_thumnail(purchase_indent_line.catalog_item.image_thumnail)
                filename = purchase_indent_line.catalog_item.image_thumnail
                if filename.nil? then filename = '' end
                if filename.strip == '' then filename = 'blank.jpg' end
                if File.exist?("#{Dir.getwd}/public/images/catalog/#{filename}") == true
                  filename = "http://#{request.env['HTTP_HOST']}/images/catalog/#{filename}"
                else
                  filename = "http://#{request.env['HTTP_HOST']}/images/catalog/blank.jpg"
                end
                xml.item_photo_url(filename)
              end
            end
          end
        end
      }
    end
  end
}
