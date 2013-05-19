# To change this template, choose Tools | Templates
# and open the template in the editor.


class Sales::PrawnPdfCrud
  include General
  def self.generate_header_for_regular_order_pdf(trans_no,y,pdf,total_height)
    sales_order = Sales::SalesOrder.active.find_by_trans_no(trans_no)
    order_id = sales_order.id
    order_date = sales_order.trans_date.to_date.strftime('%m/%d/%Y') if sales_order.trans_date
    customer_contact = sales_order.customer_contact if sales_order.customer_contact
    customer_phone = sales_order.customer_phone if sales_order.customer_phone
    ship_date = sales_order.ship_date.to_date.strftime('%m/%d/%Y') if sales_order.ship_date
    pdf.fill_color '000000'
    pdf.fill_rectangle [0,y], 200, 30
    pdf.fill_rectangle [300,y],220,30
    pdf.fill_rectangle [358,y-248],150,15
    pdf.fill_color 'FFFFFF'
    pdf.draw_text("Job No. #{trans_no}",:at => [2,y-20],:font_style => :bold,:size => 18)
    pdf.draw_text("Ship Date : #{ship_date}",:at => [305,y-20],:font_style => :bold,:size => 18)
    pdf.draw_text("REGULAR ORDER",:at => [376,y-258],:font_style => :bold,:size => 10)
    y = y - 40
    total_height = total_height + 40
    pdf.fill_color '000000'
    bill_name = sales_order.bill_name if sales_order.bill_name
    bill_address1 = sales_order.bill_address1 if sales_order.bill_address1
    bill_address2 = sales_order.bill_address2 if sales_order.bill_address2
    bill_city = sales_order.bill_city if sales_order.bill_city
    bill_state = sales_order.bill_state if sales_order.bill_state
    bill_zip = sales_order.bill_zip if sales_order.bill_zip
    bill_country = sales_order.bill_country if sales_order.bill_country
    bill_phone = sales_order.bill_phone if sales_order.bill_phone
    bill_fax = sales_order.bill_fax if sales_order.bill_fax
    table_data1 = [["Name / Address :"],
      ["#{bill_name}
                           #{bill_address1}
                           #{bill_address2}
                           #{bill_city} ,#{bill_state} ,#{bill_zip} ,#{bill_country}
                           Ph: #{bill_phone}, Fax : #{bill_fax}"]
    ]
    pdf.bounding_box([0,y],:width => 170) do
      pdf.table(table_data1,:cell_style => {:padding_top => 8 , :width => 170,:align=> :left, :size => 8,:border_width => 0.5}) do
        style(row(0),:height => 30 ,:font_style => :bold)
        style(row(1),:height => 90)
      end
    end
    ship_to_address = ""
    shipping_lines = Sales::SalesOrderShipping.active.find_all_by_sales_order_id(order_id)
    if (shipping_lines[0])
      ship_name = shipping_lines[0].ship_name if shipping_lines[0].ship_name
      ship_address1 = shipping_lines[0].ship_address1 if shipping_lines[0].ship_address1
      ship_address2 = shipping_lines[0].ship_address2 if shipping_lines[0].ship_address2
      ship_city = shipping_lines[0].ship_city if shipping_lines[0].ship_city
      ship_state = shipping_lines[0].ship_state if shipping_lines[0].ship_state
      ship_zip = shipping_lines[0].ship_zip if shipping_lines[0].ship_zip
      ship_country = shipping_lines[0].ship_country if shipping_lines[0].ship_country
      ship_phone = shipping_lines[0].ship_phone if shipping_lines[0].ship_phone
      ship_fax = shipping_lines[0].ship_fax if shipping_lines[0].ship_fax
      ship_to_address = "#{ship_name}
                                   #{ship_address1}
                                   #{ship_address2}
                                   #{ship_city}, #{ship_state}, #{ship_zip}, #{ship_country}
                                   Ph: #{ship_phone}, Fax: #{ship_fax}"
    else if(shipping_lines[1])
        ship_to_address = "SEE BELOW"
      end
    end
    table_data2 = [["Ship To :"],
      ["#{ship_to_address}"]
    ]
    pdf.bounding_box([175,y],:width => 170) do
      pdf.table(table_data2,:cell_style => {:padding_top => 8 , :width => 170,:align=> :left, :size => 8,:border_width => 0.5}) do
        style(row(0),:height => 30 ,:font_style => :bold)
        style(row(1),:height => 90)
      end
    end
    shipping_code = sales_order.shipping_code if sales_order.shipping_code
    term_code = sales_order.term_code if sales_order.term_code
    table_data3 = [["Date ","#{order_date}"],
      ["Ship Via","#{shipping_code}"],
      ["P.O. No.","#{sales_order.ext_ref_no}"],
      ["Terms","#{term_code}"]
    ]
    pdf.bounding_box([350,y],:width => 170) do
      pdf.table(table_data3,:cell_style => {:padding_top => 8 ,:width => 85,:align=> :left, :size => 8,:border_width => 0.5,:height => 29}) do
        style(column(0) ,:font_style => :bold)

      end
    end
    y = y - 125
    total_height = total_height + 125
    pdf.bounding_box([0,y],:width => 100) do
      pdf.table([["ART APPROVED"]],:cell_style => { :padding_top => 8, :width => 100, :align=> :center, :size => 8,:border_width => 0.5, :height => 30})do
        style(column(0) ,:font_style => :bold)
      end
    end
    artwork_approved = Sales::SalesOrderArtwork.active.find_all_by_final_artwork_flag_and_sales_order_id('Y',order_id)
    pdf.bounding_box([105,y],:width => 240) do
      artwork_version = artwork_approved[0].artwork_version if artwork_approved[0]
      if artwork_approved[0]
        pdf.table([["#{artwork_version}"]],:cell_style => { :padding_top => 8, :width => 240, :align=> :center, :size => 8,:border_width => 0.5, :height => 30})do
          style(column(0) ,:font_style => :bold)
        end
      end
    end


    table_data4 = [["Customer Contact "],
      ["#{customer_contact}"],
      ["Customer Phone"],
      ["#{customer_phone}"],
      [""]
    ]
    pdf.bounding_box([350,y],:width => 170) do
      pdf.table(table_data4,:cell_style => {:padding_top => 8 ,:width => 170,:align=> :center, :size => 8,:border_width => 0.5,:height => 20}) do
        style(column(0) ,:font_style => :bold)
        style(column(2) ,:font_style => :bold)
      end
    end

    y = y - 35
    total_height = total_height + 35
    pdf.bounding_box([0,y],:width => 100) do
      pdf.table([["NOTES"]],:cell_style => { :padding_top => 16, :width => 100, :align=> :center, :size => 8,:border_width => 0.5, :height => 65})do
        style(column(0) ,:font_style => :bold)
      end
    end

    pdf.bounding_box([105,y],:width => 240) do
      pdf.table([["Notes"]],:cell_style => { :padding_top => 8, :width => 240, :align=> :center, :size => 8,:border_width => 0.5, :height => 65})do
        style(column(0) ,:font_style => :bold)
      end
    end
    y = y - 75
    total_height = total_height + 75
    puts "total height for regular order pdf is #{total_height}"
    return y , total_height
  end
  def self.generate_header_for_order_ack_pdf(schema_name,sales_order,y,pdf,total_height)
    embroidery_flag = false
    company = Setup::Company.find_by_id(sales_order.company_id)
    logopath = "#{Dir.getwd}/public/images/#{schema_name}/#{company.company_logo_file}"
    if !File.exists?(logopath)
      logopath = "#{Dir.getwd}/public/images/#{schema_name}/blank.jpg"
    end
    pdf.bounding_box([0,y],:width => 270) do
      pdf.image logopath, :width => 270, :height => 50
    end
    order_date = sales_order.trans_date.to_date.strftime('%m/%d/%Y') if sales_order.trans_date
    approx_ship_date = sales_order.ship_date.to_date.strftime('%m/%d/%Y') if sales_order.ship_date
    table_data1 = [["Order#","#{sales_order.trans_no}"],
      ["Order Date","#{order_date}"],
      ["Approx Ship Date","#{approx_ship_date}"]
    ]
    y = y - 30
    total_height = total_height + 30
    pdf.bounding_box([330,y],:width => 200) do
      pdf.table(table_data1,:cell_style => { :width => 95,:align=> :center, :size => 8 ,:border_width => 0.5})
    end
    table_data = ["If you have any Question please contact
                           Customer Service at 877-835-9353 or fax your
                           Correction to 631-694-5568, within 24 hours.

                          * This order may be pending approval of Artwork *"]
    table_data7 = [table_data]
    table_data8 = [ table_data,
      ["Embroidery Item Pricing will be updated after
                        Artwork Confirmation  and Digitizing Done."]]
    y = y - 70
    total_height = total_height + 70
    sales_order_attributes_values = []
    sales_order.sales_order_attributes_values.each{|sales_order_attributes_value|
      if sales_order_attributes_value == 'A'
        sales_order_attributes_values << sales_order_attributes_value
      end
    }
    sales_order_attributes_values.each{|attribute_value|
      if (attribute_value.catalog_attribute_code == CATALOG_ATTRIBUTE_CODE and attribute_value.catalog_attribute_value_code == ATTRIBUTE_VALUE_EMBROIDERY)
        embroidery_flag = true
      end
      break
    }
    if (embroidery_flag == true and sales_order.orderacksent_flag == 'N')
      pdf.bounding_box([330,y],:width => 200) do
        pdf.table(table_data8,:cell_style => {:height =>80, :width => 190,:align=> :left, :size => 7 ,:font_style => :bold,:border_width => 0.5})do
          style(row(0),:height => 40 )
          style(row(1),:height => 40,:text_color =>"FF0000")
        end
      end
    else
      pdf.bounding_box([330,y],:width => 200) do
        pdf.table(table_data7,:cell_style => {:height =>80, :width => 190,:align=> :left, :size => 6 ,:font_style => :bold,:border_width => 0.5})
      end
    end
    bill_name = sales_order.bill_name if sales_order.bill_name
    bill_address1 = sales_order.bill_address1 if sales_order.bill_address1
    bill_address2 = sales_order.bill_address2 if sales_order.bill_address2
    bill_city = sales_order.bill_city if sales_order.bill_city
    bill_state = sales_order.bill_state if sales_order.bill_state
    bill_zip = sales_order.bill_zip if sales_order.bill_zip
    bill_country = sales_order.bill_country if sales_order.bill_country
    bill_phone = sales_order.bill_phone if sales_order.bill_phone
    bill_fax = sales_order.bill_fax if sales_order.bill_fax
    table_data2 = [["Sold To:"],
      ["#{bill_name}
              #{bill_address1}
              #{bill_address2}
              #{bill_city} ,#{bill_state} ,#{bill_zip} ,#{bill_country}
              Ph: #{bill_phone}, Fax : #{bill_fax}"]
    ]

    y = y + 40
    total_height = total_height - 40
    pdf.bounding_box([0,y],:width => 170) do
      pdf.table(table_data2,:cell_style => { :width => 160,:align=> :left, :size => 8 ,:border_width => 0.5}) do
        style(row(0),:height => 30 )
        style(row(1),:height => 90)
      end
    end
    ship_to_address =""
    shipping_lines = []
    sales_order.sales_order_shippings.each{|sales_order_shipping|
      if sales_order_shipping.trans_flag == 'A'
        shipping_lines << sales_order_shipping
      end
    }
    if(shipping_lines[1])
      ship_to_address = "SEE BELOW"
    elsif (shipping_lines[0])
      ship_name = shipping_lines[0].ship_name if shipping_lines[0].ship_name
      ship_address1 = shipping_lines[0].ship_address1 if shipping_lines[0].ship_address1
      ship_address2 = shipping_lines[0].ship_address2 if shipping_lines[0].ship_address2
      ship_city = shipping_lines[0].ship_city if shipping_lines[0].ship_city
      ship_state = shipping_lines[0].ship_state if shipping_lines[0].ship_state
      ship_zip = shipping_lines[0].ship_zip if shipping_lines[0].ship_zip
      ship_country = shipping_lines[0].ship_country if shipping_lines[0].ship_country
      ship_phone = shipping_lines[0].ship_phone if shipping_lines[0].ship_phone
      ship_fax = shipping_lines[0].ship_fax if shipping_lines[0].ship_fax
      ship_method = shipping_lines[0].ship_method if shipping_lines[0].ship_method
      ship_to_address = "#{ship_name}
                                   #{ship_address1}
                                   #{ship_address2}
                                   #{ship_city}, #{ship_state}, #{ship_zip}, #{ship_country}
                                   Ph: #{ship_phone}, Fax: #{ship_fax}"

    end
    table_data3 = [["Ship To:"],
      ["#{ship_to_address}"]
    ]
    pdf.bounding_box([165,y],:width => 170) do
      pdf.table(table_data3,:cell_style => { :width => 160,:align=> :left, :size => 8,:border_width => 0.5}) do
        style(row(0),:height => 30 )
        style(row(1),:height => 90)
      end
    end
    y = y - 130
    total_height = total_height + 130
    salesperson_code = sales_order.salesperson_code if sales_order.salesperson_code
    term_code = sales_order.term_code if sales_order.term_code
    table_data4 = [["Purchase order No.","Customer ID","Sales Rep","Payment Terms","Shipping Method"],
      ["#{sales_order.ext_ref_no}","#{sales_order.customer_code}","#{salesperson_code}","#{term_code}","#{ship_method}"]
    ]
    pdf.bounding_box([0,y],:width => 800) do
      pdf.table(table_data4,:cell_style => { :width => 104,:align=> :center,:size => 8,:border_width => 0.5})
    end

    pdf.fill_color '808080'
    pdf.fill_rectangle [320,740], 200, 30
    pdf.fill_color 'FFFFFF'
    pdf.draw_text("ACKNOWLEDGEMENT",:at => [320,715],:font_style => :bold,:size => 18)
    pdf.fill_color '000000'
    y = y - 50
    total_height = total_height + 50
    return y,total_height
  end

  def self.fetch_item_lines_for_order_ack_pdf(sales_order,y,pdf,total_height)
    table_data5 = [["Item","Description","Ordered","Unit Price","Ext. Price"]]
    pdf.bounding_box([0,y],:width => 520) do
      pdf.table(table_data5,:cell_style => {:border_color =>"98AFC7",:width => 50,:align=> :left,:size => 7,:border_width => 0.5,:font_style => :bold })do
        style(column(1),:width => 260,:overflow => :shrink_to_fit)
        style(column(0),:width => 110)
      end
      y = y - 15
      total_height = total_height + 15
    end
    sales_order_lines = []
    sales_order.sales_order_lines.each{|sales_order_line|
      if sales_order_line.trans_flag == 'A'
        sales_order_lines << sales_order_line
      end
    }
    sales_order_lines.each do |line|
      catalog_item_code = line.catalog_item_code if line.catalog_item_code
      item_description = line.item_description if line.item_description
      catalog_item_id = line.catalog_item_id if line.catalog_item_id
      item_qty = line.item_qty.to_i if line.item_qty
      item_price = line.item_price.to_f if line.item_price
      item_amt = line.item_amt.to_f if line.item_amt
      item_amt = '%.2f'%item_amt if line.item_amt
      y, total_height = check_for_start_new_page_for_order_ack_pdf(y,pdf,total_height)
      if(total_height == 240)
        pdf.bounding_box([0,y],:width => 520) do
          pdf.table(table_data5,:cell_style => {:border_color =>"98AFC7",:width => 50,:align=> :left,:size => 7,:border_width => 0.5,:font_style => :bold })do
            style(column(1),:width => 260,:overflow => :shrink_to_fit)
            style(column(0),:width => 110)
          end
          y = y - 18
          total_height = total_height + 19
        end
      end
      pdf.bounding_box([0,y],:width => 800) do
        pdf.table([["#{catalog_item_code}","#{item_description}","#{item_qty}","#{item_price}","#{item_amt}"]],
          :cell_style => {:border_color =>"98AFC7",:width => 50,:align=> :left,:size => 7,:borders => [:left],:border_width => 0,:height => 25 }) do
          style(column(1),:width => 260,:borders => [:left],:border_width => 0.5,:height => 25,:overflow => :truncate)
          style(column(0),:width => 110,:borders => [:left],:border_left_width => 0.5,:height => 25)
          style(column(2),:borders => [:left],:border_width => 0.5,:height => 25)
          style(column(3),:borders => [:left],:border_width => 0.5,:height => 25)
          style(column(4),:borders => [:right,:left],:border_width => 0.5,:height => 25)

        end
        y = y - 25
        total_height = total_height + 25
      end
      if line.item_type == 'I'
        attribute_values = []
        if (sales_order.trans_type != TRANS_TYPE_REGULAR_ORDER and sales_order.trans_type != TRANS_TYPE_REORDER and sales_order.trans_type != TRANS_TYPE_PREPRODUCTION_ORDER)
          line.sales_order_attributes_values.each{|sales_order_attributes_value|
            if sales_order_attributes_value.trans_flag == 'A'
              attribute_values << sales_order_attributes_value
            end
          }
        else
          sales_order.sales_order_attributes_values.each{|sales_order_attributes_value|
            if sales_order_attributes_value.trans_flag == 'A'
              attribute_values << sales_order_attributes_value
            end
          }
        end
        attribute_values.each{|value|
          y, total_height = check_for_start_new_page_for_order_ack_pdf(y,pdf,total_height)
          if(total_height == 240)
            pdf.bounding_box([0,y],:width => 520) do
              pdf.table(table_data5,:cell_style => {:border_color =>"98AFC7",:width => 50,:align=> :left,:size => 7,:border_width => 0.5,:font_style => :bold ,:height => 25})do
                style(column(1),:width => 260)
                style(column(0),:width => 110)
              end
              y = y - 25
              total_height = total_height + 25
            end
          end
          catalog_attribute_value_code = value.catalog_attribute_value_code.to_s
          if catalog_attribute_value_code == ''
            missing_order_info = sales_order.missing_order_info.to_s
            catalog_attribute_code = value.catalog_attribute_code
            if missing_order_info != '' and missing_order_info =~ /(.*)#{catalog_attribute_code}(.*)/
              missing_attribute_code = catalog_attribute_code
              if missing_attribute_code
                catalog_attribute = Item::CatalogAttribute.active.find_by_code_and_missing_info_required_flag("#{catalog_attribute_code}",'Y')
                if catalog_attribute
                  catalog_item_attributes_value = Item::CatalogItemAttributesValue.active.find_by_catalog_item_id_and_catalog_attribute_id_and_default_value(catalog_item_id,catalog_attribute.id,'Y')
                  if catalog_item_attributes_value
                    catalog_attribute_value = Item::CatalogAttributeValue.active.find_by_id(catalog_item_attributes_value.catalog_attribute_value_id)
                    if catalog_attribute_value
                      pdf.bounding_box([0,y],:width => 800) do
                        pdf.table([["","#{value.catalog_attribute_code}: Not Selected ; Default is (#{catalog_attribute_value.code})","","",""]],
                          :cell_style => {:border_color =>"98AFC7",:width => 50,:align=> :left,:size => 7,:border_width => 0 ,:height => 25}) do
                          style(column(0),:width => 110,:border_left_width => 0.5)
                          style(column(1),:width => 260,:borders => [:left],:border_width => 0.5,:overflow => :shrink_to_fit)
                          style(column(2),:borders => [:left],:border_width => 0.5)
                          style(column(3),:borders => [:left],:border_width => 0.5)
                          style(column(4),:borders => [:right,:left],:border_width => 0.5)
                        end
                        y = y - 25
                        total_height = total_height + 25
                      end
                    end
                  end
                end
              end
            end
          else
            pdf.bounding_box([0,y],:width => 800) do
              pdf.table([["","#{value.catalog_attribute_code}: #{value.catalog_attribute_value_code}: #{value.remarks}","","",""]],
                :cell_style => {:border_color =>"98AFC7",:width => 50,:align=> :left,:size => 7,:border_width => 0 ,:height => 25}) do
                style(column(0),:width => 110,:border_left_width => 0.5)
                style(column(1),:width => 260,:borders => [:left],:border_width => 0.5,:overflow => :shrink_to_fit)
                style(column(2),:borders => [:left],:border_width => 0.5)
                style(column(3),:borders => [:left],:border_width => 0.5)
                style(column(4),:borders => [:right,:left],:border_width => 0.5)
              end
              y = y - 25
              total_height = total_height + 25
            end
          end
        }
      end
      pdf.bounding_box([0,y],:width => 800) do
        pdf.table([["","","","",""]],:cell_style => {:border_color =>"98AFC7",:width => 50,:align=> :left,:size => 7,:height =>0.5})do
          style(column(1),:width => 260)
          style(column(0),:width => 110)
          style(row(0),:borders => [:bottom])
        end
      end
    end
    y = y - 20
    total_height = total_height + 20
    return y,total_height
  end
  def self.fetch_item_lines_for_regular_order_pdf(schema_name,sales_order,y,pdf,total_height)
    order_lines = Sales::SalesOrderLine.active.find_all_by_sales_order_id(sales_order.id,:order =>"line_type")
    attribute_values = Sales::SalesOrderAttributesValue.active.find_all_by_sales_order_id(sales_order.id)
    if order_lines
      table_data5 = [["Item","Description","Ordered","Unit Price","Ext. Price"]]
      pdf.bounding_box([0,y],:width => 520) do
        pdf.table(table_data5,:cell_style => {:border_color =>"98AFC7",:width => 50,:align=> :left,:size => 7,:border_width => 0.5,:font_style => :bold })do
          style(column(1),:width => 260)
          style(column(0),:width => 110)
        end
        y = y - 15
        total_height = total_height + 15
      end
    end

    order_lines.each do |line|
      catalog_item_code = line.catalog_item_code if line.catalog_item_code
      item_description = line.item_description if line.item_description
      serial_no = line.serial_no if line.serial_no
      item_qty = line.item_qty if line.item_qty
      item_price = line.item_price if line.item_price
      item_amt = line.item_amt if line.item_amt
      y, total_height = check_for_start_new_page_for_regular_order_pdf(y,pdf,total_height)
      if(total_height == 275)
        pdf.bounding_box([0,y],:width => 520) do
          pdf.table(table_data5,:cell_style => {:border_color =>"98AFC7",:width => 50,:align=> :left,:size => 7,:border_width => 0.5,:font_style => :bold })do
            style(column(1),:width => 260)
            style(column(0),:width => 110)
          end
          y = y - 18
          total_height = total_height + 19
        end
      end
      pdf.bounding_box([0,y],:width => 800) do
        pdf.table([["#{catalog_item_code}","#{item_description}","#{item_qty}","#{item_price}","#{item_amt}"]],
          :cell_style => {:border_color =>"98AFC7",:width => 50,:align=> :left,:size => 8,:border_width => 0,:height => 30 }) do
          style(column(1),:width => 260,:borders => [:left],:border_width => 0.5,:height => 30)
          style(column(0),:width => 110,:borders => [:left],:border_left_width => 0.5,:height => 30)
          style(column(2),:borders => [:left],:border_width => 0.5,:height => 30)
          style(column(3),:borders => [:left],:border_width => 0.5,:height => 30)
          style(column(4),:borders => [:right,:left],:border_width => 0.5,:height => 30)
          #                       style(row(last_row),:borders => [:bottom],:border_bottom_width => 0.5,:height => 30)
        end
        y = y - 30
        total_height = total_height + 30
      end

      if line.item_type == 'I'
        attribute_values = Sales::SalesOrderAttributesValue.active.find_all_by_sales_order_id(sales_order.id)
        attribute_values.each{|value|
          y, total_height = check_for_start_new_page_for_regular_order_pdf(y,pdf,total_height)
          if(total_height == 275)
            pdf.bounding_box([0,y],:width => 520) do
              pdf.table(table_data5,:cell_style => {:border_color =>"98AFC7",:width => 50,:align=> :left,:size => 7,:border_width => 0.5,:font_style => :bold ,:height => 25})do
                style(column(1),:width => 260)
                style(column(0),:width => 110)
              end
              y = y - 25
              total_height = total_height + 25
            end
          end
          if value.catalog_attribute_value_code != ''
            pdf.bounding_box([0,y],:width => 800) do
              pdf.table([["","#{value.catalog_attribute_code}:#{value.catalog_attribute_value_code}","","",""]],
                :cell_style => {:border_color =>"98AFC7",:width => 50,:align=> :left,:size => 7 ,:height => 25}) do
                style(column(0),:width => 110,:borders => [:left],:border_width => 0.5,:height => 25)
                style(column(1),:width => 260,:borders => [:left],:border_width => 0.5,:height => 25)
                style(column(2),:borders => [:left],:border_width => 0.5,:height => 25)
                style(column(3),:borders => [:left],:border_width => 0.5,:height => 25)
                style(column(4),:borders => [:right,:left],:border_width => 0.5,:height => 25)
              end
              y = y - 25
              total_height = total_height + 25
            end
          end
        }

      end
      pdf.bounding_box([0,y],:width => 800) do
        pdf.table([["","","","",""]],:cell_style => {:border_color =>"98AFC7",:width => 50,:align=> :left,:size => 7,:height =>0.5})do
          style(column(1),:width => 260)
          style(column(0),:width => 110)
          style(row(0),:borders => [:bottom])
        end

      end

    end
    y = y - 50
    total_height = total_height + 50

    return y,total_height
  end
  def self.fetch_item_lines_for_regular_order_job_pdf(trans_no,y,pdf,total_height)
    table_data5 = [["Item","Description","Ordered"]]
    pdf.bounding_box([0,y],:width => 550) do
      pdf.table(table_data5,:cell_style => {:border_color =>"98AFC7",:width => 112,:align=> :center,:size => 8,:border_width => 0.5,:font_style => :bold ,:height => 25})do
        style(column(1),:width => 300)
        style(column(0),:width => 110)
      end
    end
    y = y - 25
    total_height = total_height + 25
    sales_order = Sales::SalesOrder.active.find_by_trans_no(trans_no)
    order_lines = Sales::SalesOrderLine.active.find_all_by_trans_no(trans_no,:order =>"item_type")
    attribute_values = Sales::SalesOrderAttributesValue.active.find_all_by_sales_order_id(sales_order.id)
    last_row = order_lines.size-1
    order_lines.each do |line|
      catalog_item_code = line.catalog_item_code if line.catalog_item_code
      item_description = line.item_description if line.item_description
      item_qty = line.item_qty if line.item_qty
      y, total_height = check_for_start_new_page_for_regular_order_pdf(y,pdf,total_height)
      if(total_height == 275)
        pdf.bounding_box([0,y],:width => 550) do
          pdf.table(table_data5,:cell_style => {:border_color =>"98AFC7",:width => 112,:align=> :center,:size => 8,:border_width => 0.5,:font_style => :bold ,:height => 25})do
            style(column(1),:width => 300)
            style(column(0),:width => 110)
          end
          y = y - 25
          total_height = total_height + 25
        end
      end
      pdf.bounding_box([0,y],:width => 800) do
        pdf.table([["#{catalog_item_code}","#{item_description}","#{item_qty}"]],
          :cell_style => {:border_color =>"98AFC7",:width => 112,:align=> :left,:size => 7,:borders => [:left],:border_width => 0,:height => 30 }) do
          style(column(1),:width => 300,:borders => [:left],:border_width => 0.5,:height => 30,:overflow => :truncate,:min_font_size => 7)
          style(column(0),:width => 110,:borders => [:left],:border_left_width => 0.5,:height => 30)
          style(column(2),:borders => [:left,:right],:border_width => 0.5,:height => 30)

          style(row(last_row),:borders => [:bottom],:border_bottom_width => 0.5,:height => 30)
        end
        y = y - 25
        total_height = total_height + 25
      end

      if line.item_type == 'I'
        attribute_values.each{|value|
          y, total_height = check_for_start_new_page_for_regular_order_pdf(y,pdf,total_height)
          if(total_height == 275)
            pdf.bounding_box([0,y],:width => 550) do
              pdf.table(table_data5,:cell_style => {:border_color =>"98AFC7",:width => 112,:align=> :center,:size => 8,:border_width => 0.5,:font_style => :bold ,:height => 25})do
                style(column(1),:width => 300,:height => 25)
                style(column(0),:width => 110,:height => 25)
              end
              y = y - 25
              total_height = total_height + 25
            end
          end


          if value.catalog_attribute_value_code != ''
            pdf.bounding_box([0,y],:width => 800) do
              pdf.table([["","#{value.catalog_attribute_code}:#{value.catalog_attribute_value_code}","","",""]],
                :cell_style => {:border_color =>"98AFC7",:padding_left => 12,:width => 112,:align=> :left,:size => 7,:borders => [:left],:border_width => 0 ,:height => 25}) do
                style(column(1),:width => 300,:borders => [:left],:border_width => 0.5,:height => 25)
                style(column(0),:width => 110,:borders => [:left],:border_left_width => 0.5,:height => 25)
                style(column(2),:width => 112,:borders => [:left,:right],:border_width => 0.5,:height => 25)
              end
              y = y - 25
              total_height = total_height + 25
            end


          end
        }
      end
    end
    y = y - 50
    total_height = total_height + 50

    return y,total_height
  end

  def self.fetch_shipping_lines_for_order_ack_pdf(total_height,order,y,pdf)
    shipping_lines = []
    order.sales_order_shippings.each{|sales_order_shipping|
      if sales_order_shipping.trans_flag == 'A'
        shipping_lines << sales_order_shipping
      end
    }
    if(shipping_lines[1])
      y, total_height = check_for_start_new_page_for_order_ack_pdf(y,pdf,total_height)
      pdf.bounding_box([0,y],:width => 600) do
        pdf.text_box("Shipping",:align => :center,:style =>:bold)
        y = y - 30
        total_height = total_height + 30
      end
      table_data6=[["Qty","Name","Address1","Address2","City","State","Zip","Country"]]
      y, total_height = check_for_start_new_page_for_order_ack_pdf(y,pdf,total_height)
      pdf.bounding_box([0,y],:width => 800) do
        pdf.table(table_data6,:cell_style => {:width => 40,:align=> :center,:size => 8 ,:border_width => 0.5,:font_style => :bold,:height => 25}) do
          style(column(0),:width => 40,:height => 25)
          style(column(1),:width => 60,:height => 25)
          style(column(2),:width =>130,:height => 25)
          style(column(3),:width =>130,:height => 25)
        end
        y = y - 25
        total_height = total_height + 25
      end

      shipping_lines.each do |shipping_line|
        if shipping_line.trans_flag == 'A'
          ship_qty = shipping_line.ship_qty if shipping_line.ship_qty
          ship_name = shipping_line.ship_name if shipping_line.ship_name
          ship_address1 = shipping_line.ship_address1 if shipping_line.ship_address1
          ship_address2 = shipping_line.ship_address2 if shipping_line.ship_address2
          ship_city = shipping_line.ship_city if shipping_line.ship_city
          ship_state = shipping_line.ship_state if shipping_line.ship_state
          ship_country = shipping_line.ship_country if shipping_line.ship_country
          ship_zip = shipping_line.ship_zip if shipping_line.ship_zip
          y, total_height = check_for_start_new_page_for_order_ack_pdf(y,pdf,total_height)
          if(total_height == 240)

            pdf.bounding_box([0,y],:width => 800) do
              pdf.table(table_data6,:cell_style => {:width => 40,:align=> :center,:size => 8 ,:border_width => 0.5,:font_style => :bold,:height => 25}) do
                style(column(0),:width => 40,:height => 25)
                style(column(1),:width => 60,:height => 25)
                style(column(2),:width =>130,:height => 25)
                style(column(3),:width =>130,:height => 25)
              end
              y = y - 25
              total_height = total_height + 25
            end
          end
          pdf.bounding_box([0,y],:width => 800) do
            pdf.table([["#{ship_qty}","#{ship_name}","#{ship_address1}","#{ship_address2}","#{ship_city}","#{ship_state}","#{ship_zip}","#{ship_country}"]],
              :cell_style => {:width => 40,:align=> :center,:size => 8 ,:border_width => 0,:height => 25}) do
              style(column(0),:width => 40,:height => 25)
              style(column(1),:width => 60,:height => 25)
              style(column(2),:width =>130,:height => 25)
              style(column(3),:width =>130,:height => 25)
            end
            y = y - 25
            total_height = total_height + 25
          end
        end
      end
    end
    return y,total_height
  end

  def self.fetch_shipping_lines_for_regular_order_pdf(total_height,order_id,y,pdf)
    shipping_lines = Sales::SalesOrderShipping.active.find_all_by_sales_order_id(order_id)
    if(shipping_lines[1])
      y, total_height = check_for_start_new_page_for_regular_order_pdf(y,pdf,total_height)
      pdf.bounding_box([0,y],:width => 600) do
        pdf.text_box("Shipping",:align => :center,:style =>:bold)
        y = y - 30
        total_height = total_height + 30
      end
      table_data6=[["Qty","Name","Address1","Address2","City","State","Zip","Country"]]
      y, total_height = check_for_start_new_page_for_regular_order_pdf(y,pdf,total_height)
      pdf.bounding_box([0,y],:width => 800) do
        pdf.table(table_data6,:cell_style => {:width => 40,:align=> :center,:size => 8 ,:border_width => 0.5,:font_style => :bold,:height => 25}) do
          style(column(0),:width => 40,:height => 25)
          style(column(1),:width => 60,:height => 25)
          style(column(2),:width =>130,:height => 25)
          style(column(3),:width =>130,:height => 25)
        end
        y = y - 25
        total_height = total_height + 25
      end

      shipping_lines.each do |shipping_line|
        ship_qty = shipping_line.ship_qty if shipping_line.ship_qty
        ship_name = shipping_line.ship_name if shipping_line.ship_name
        ship_address1 = shipping_line.ship_address1 if shipping_line.ship_address1
        ship_address2 = shipping_line.ship_address2 if shipping_line.ship_address2
        ship_city = shipping_line.ship_city if shipping_line.ship_city
        ship_state = shipping_line.ship_state if shipping_line.ship_state
        ship_country = shipping_line.ship_country if shipping_line.ship_country
        ship_zip = shipping_line.ship_zip if shipping_line.ship_zip
        y, total_height = check_for_start_new_page_for_regular_order_pdf(y,pdf,total_height)
        if(total_height == 275)

          pdf.bounding_box([0,y],:width => 800) do
            pdf.table(table_data6,:cell_style => {:width => 40,:align=> :center,:size => 8 ,:border_width => 0.5,:font_style => :bold,:height => 25}) do
              style(column(0),:width => 40,:height => 25)
              style(column(1),:width => 60,:height => 25)
              style(column(2),:width =>130,:height => 25)
              style(column(3),:width =>130,:height => 25)
            end
            y = y - 25
            total_height = total_height + 25
          end
        end
        pdf.bounding_box([0,y],:width => 800) do
          pdf.table([["#{ship_qty}","#{ship_name}","#{ship_address1}","#{ship_address2}","#{ship_city}","#{ship_state}","#{ship_zip}","#{ship_country}"]],
            :cell_style => {:width => 40,:align=> :center,:size => 8 ,:border_width => 0,:height => 25}) do
            style(column(0),:width => 40,:height => 25)
            style(column(1),:width => 60,:height => 25)
            style(column(2),:width =>130,:height => 25)
            style(column(3),:width =>130,:height => 25)
          end
          y = y - 25
          total_height = total_height + 25
        end

      end
      y = y - 25
      total_height = total_height + 25
    end
    return y,total_height
  end


  def self.generate_footer_for_regular_order_pdf(trans_no,y, pdf,total_height)
    sales_order = Sales::SalesOrder.active.find_by_trans_no(trans_no)
    correspondence_email = sales_order.corr_dept_email if sales_order.corr_dept_email
    account_dept_email = sales_order.account_dept_email if sales_order.account_dept_email
    shipping_dept_email = sales_order.shipping_dept_email if sales_order.shipping_dept_email
    purchase_dept_email = sales_order.purchase_dept_email if sales_order.purchase_dept_email
    artwork_dept_email = sales_order.artwork_dept_email if sales_order.artwork_dept_email
    pdf.fill_color '000000'
    total_height = total_height+ 80
    y, total_height = check_for_start_new_page_for_regular_order_pdf(y, pdf, total_height)
    pdf.bounding_box([0,y],:width => 600) do
      table_data_email = [["Correspondence : #{correspondence_email}","Account : #{account_dept_email}"],
        ["Shipping : #{shipping_dept_email}","Purchase : #{purchase_dept_email}"],
        ["Artwork : #{artwork_dept_email}"]
      ]
      email_table = pdf.make_table(table_data_email,:cell_style => {:padding_top => 8 ,:padding_right => 50,:width => 260,:align=> :right, :size => 8,:border_width => 0,:height => 20})do |table|
        table.column(0).style :align => :left
      end
      pdf.table([["Emails"],
          [email_table]

        ]) do |table|

        table.row(0).style :align => :center,:border_width => 0.5
        table.row(1).style :border_width => 0.5

      end
    end


  end

  def self.generate_footer_for_order_ack_pdf(pdf,schema_name,order)

    grand_total = (nulltozero(order.item_amt)).to_f
    shipping_amt = (nulltozero(order.ship_amt)).to_f
    other_amt = (nulltozero(order.other_amt)).to_f
    net_amt = (nulltozero(order.net_amt)).to_f
    item_qty = (nulltozero(order.item_qty)).to_i
    table_data3 = [["Total Quantity : #{item_qty}"],
      [""]
    ]
    pdf.bounding_box([0,122],:width => 360) do
      pdf.table(table_data3,:cell_style =>{:width => 360,:size => 7,:align => :left, :overflow => :truncate,:border_width => 0.5,:height => 20}) do |table|
        table.row(0).style :height => 20
        table.row(1).style :height => 60
      end
    end
    pdf.bounding_box([362,122],:width => 312) do
      table_data2 = [["Grand Total : ","#{grand_total}"],
        ["Shipping : ","#{shipping_amt}"],
        ["Other Amount : ","#{other_amt}"],
        ["Net Amount : ","#{net_amt}"]
      ]
      pdf.table(table_data2,:cell_style =>{:width => 110,:size => 7,:align => :left, :overflow => :truncate,:border_width => 0.5,:height => 20}) do |table|
        table.column(1).style :width => 50
      end
    end

    order_ack_footer_image = "#{Rails.root}/public/images/#{schema_name}/order_ack_footer_image.jpg"
    if !order_ack_footer_image
      order_ack_footer_image = "#{Rails.root}/public/images/#{schema_name}/blank.jpg"
    end
    pdf.bounding_box([0,40],:width => 550) do
      pdf.image order_ack_footer_image, :width => 522, :height => 40
    end
  end

  def self.check_for_start_new_page_for_order_ack_pdf(y,pdf,total_height)
    if total_height > 590
      pdf.start_new_page
      y = 730 - 240
      total_height = 240
    end
    return y , total_height
  end

  def self.check_for_start_new_page_for_regular_order_pdf(y,pdf,total_height)
    if total_height > 700
      y = 730 - 275
      total_height = 275
      pdf.start_new_page

    end
    return y , total_height
  end
  def self.insert_page_numbers(pdf)
    string = "page <page> of <total>"
    options = { :at => [pdf.bounds.right - 130, 740],
      :width => 150,
      :align => :right,
      :page_filter => :all,
      :start_count_at => 1,
      :color => "000000",
      :size =>7}
    pdf.number_pages string, options

  end

  def self.generate_header_for_sales_invoice_pdf(pdf,schema_name,sales_invoice)
    company = Setup::Company.find_by_id(sales_invoice.company_id)
    header_image_path = "#{Dir.getwd}/public/images/#{schema_name}/#{company.company_logo_file}"
    if !File.exists?(header_image_path)
      header_image_path = "#{Dir.getwd}/public/images/#{schema_name}/blank.jpg"
    end
    invoice_number = nulltozero(sales_invoice.trans_no)
    invoice_date = sales_invoice.trans_date.to_date.strftime("%b %d, %Y") if sales_invoice.trans_date
    term = Setup::Term.find_by_code(sales_invoice.term_code) if sales_invoice.term_code
    term_name = term.name if term.name
    pdf.repeat :all do                                                           #start of page header
      pdf.image  header_image_path, :width => 400, :height => 50, :position => :left
      pdf.font_size(20){
        pdf.text_rendering_mode(:fill_stroke) do
          pdf.text_box " I N V O I C E",:at =>[425,770],:font => "Times-Roman"                                #order header
        end
      }
      pdf.stroke_color "11111"
      pdf. fill_color "111111"
      pdf. font_size(8) {
        pdf.text_box "Page         :", :at=>[425,790]
      }

      pdf.bounding_box([425,740],:width => 150,:height=>55) do
        #        pdf.stroke_bounds
        pdf.table([["Date","Invoice"],[" #{invoice_date}","#{invoice_number}"]],:column_widths => {0 => 65, 1 =>65},:cell_style => {:overflow => :shrink_to_fit,:height => 25}) do
          row(0).font_style = :bold
          values = cells.columns(0..1).rows(0)
          values.background_color = "F0F0F0"
        end

      end
      bill_name = sales_invoice.bill_name if sales_invoice.bill_name
      bill_address1 = sales_invoice.bill_address1 if sales_invoice.bill_address1
      bill_address2 = sales_invoice.bill_address2 if sales_invoice.bill_address2
      bill_city = sales_invoice.bill_city if sales_invoice.bill_city
      bill_state = sales_invoice.bill_state if sales_invoice.bill_state
      bill_zip = sales_invoice.bill_zip if sales_invoice.bill_zip
      bill_country = sales_invoice.bill_country if sales_invoice.bill_country
      bill_phone = sales_invoice.bill_phone if sales_invoice.bill_phone
      bill_fax = sales_invoice.bill_fax if sales_invoice.bill_fax
      bill_to_address = "#{bill_name}
#{bill_address1}
#{bill_address2}
#{bill_city} ,#{bill_state} ,#{bill_zip} ,#{bill_country}
Ph: #{bill_phone}, Fax : #{bill_fax}"
      ship_name = sales_invoice.ship_name if sales_invoice.ship_name
      ship_address1 = sales_invoice.ship_address1 if sales_invoice.ship_address1
      ship_address2 = sales_invoice.ship_address2 if sales_invoice.ship_address2
      ship_city = sales_invoice.ship_city if sales_invoice.ship_city
      ship_state = sales_invoice.ship_state if sales_invoice.ship_state
      ship_zip = sales_invoice.ship_zip if sales_invoice.ship_zip
      ship_country = sales_invoice.ship_country if sales_invoice.ship_country
      ship_phone = sales_invoice.ship_phone if sales_invoice.ship_phone
      ship_fax = sales_invoice.ship_fax if sales_invoice.ship_fax
      ship_to_address = "#{ship_name}
#{ship_address1}
#{ship_address2}
 #{ship_city} ,#{ship_state} ,#{ship_zip} ,#{ship_country}
 Ph: #{ship_phone}, Fax : #{ship_fax}"

      puts bill_to_address
      pdf.bounding_box([0,660],:width => 275,:height=>125) do
        #        pdf.stroke_bounds
        pdf.table([[" BILL TO "]],:column_widths => {0 =>275},:cell_style => {:height => 25}) do   #bill to
          row(0).font_style = :bold
          values = cells.columns(0..1).rows(0)

          values.background_color = "F0F0F0"
        end
        pdf.font_size(10){
          pdf.table([["#{bill_name}\n#{ship_address1}\n#{bill_address1}\n#{bill_address2}\n#{bill_city} ,#{bill_state} ,#{bill_zip} ,#{bill_country}\nPh: #{bill_phone}, Fax : #{bill_fax}
                "]] ,:column_widths => {0 =>275},:cell_style => {:height =>90}) do

          end}

      end
      pdf.bounding_box([285,660],:width => 275,:height=>125) do
        pdf.table([[" SHIP TO"]],:column_widths => {0 =>275},:cell_style => {:height => 25}) do       #ship to
          row(0).font_style = :bold
          values = cells.columns(0..1).rows(0)

          values.background_color = "F0F0F0"
        end
        pdf.font_size(10){
          pdf.table([["#{ship_name}\n#{ship_address1}\n#{ship_address2}\n#{ship_city} ,#{ship_state} ,#{ship_zip} ,#{ship_country}\nPh: #{ship_phone}, Fax : #{ship_fax}"]] ,:column_widths => {0 =>275},:cell_style => {:height =>90}) do
          end
        }
      end
      #body
      customer_po = sales_invoice.ext_ref_no if sales_invoice.ext_ref_no
      customer_po_date = sales_invoice.ext_ref_date.to_date.strftime('%m/%d/%Y') if sales_invoice.ext_ref_date
      ship_via = sales_invoice.shipping_code if sales_invoice.shipping_code
      ship_date = sales_invoice.ship_date.to_date.strftime('%m/%d/%Y') if sales_invoice.ship_date
      job =sales_invoice.ref_trans_no if sales_invoice.ref_trans_no
      pdf.bounding_box([0,540],:width => 560,:height=>50) do
        pdf.table([["CUSTOMER PO","TERM","SHIP VIA","SHIP DATE","ACCT #","JOB"],["#{customer_po}","#{term_name}","#{ship_via}","#{ ship_date}","#{customer_po_date}","#{job}"]],:column_widths => {0 => 100, 1 =>80, 2=>110,3=>100,4 =>100, 5=>70},:cell_style => {:overflow => :shrink_to_fit, :height => 25}) do
          row(0).font_style = :bold
          values = cells.columns(0..5).rows(0)
          values.background_color = "F0F0F0"
        end

      end
      pdf.move_down 5
    end                     #end header
    return pdf

  end

  def self.fetch_lines_for_sales_invoice_pdf(pdf,sales_invoice)
    sales_invoice_id = sales_invoice.id
    line_count = 1
    sales_invoice_lines = Sales::SalesInvoiceLine.active.find_all_by_sales_invoice_id(sales_invoice_id,:order => 'item_type')
    pdf.bounding_box([0,470],:width => 560,:height=>400) do
      #    pdf.stroke_bounds
      pdf.table([["ITEM CODE","DESCRIPTION","Item Qty","Item Price","Item Amt","Net Amt"]],:column_widths => {0 =>100, 1 =>180, 2=>65,3=>75, 4=>70,5 =>70},:cell_style => {:height => 25}) do
        row(0).font_style = :bold
        values = cells.columns(0..5).rows(0)
        values.background_color = "F0F0F0"
      end
      sales_invoice_lines.each do |sales_invoice_line|
        item_code = nulltozero(sales_invoice_line.catalog_item_code)
        item_qty = nulltozero(sales_invoice_line.item_qty.to_i)
        item_description = nulltozero(sales_invoice_line.item_description)
        item_price = nulltozero(sales_invoice_line.item_price.to_f)
        item_amt = nulltozero(sales_invoice_line.item_amt.to_f)
        net_amt = nulltozero(sales_invoice_line.net_amt.to_f)
        line_count = line_count + 1
        pdf.font_size(10){

          pdf.table([["#{item_code}","#{item_description}","#{item_qty}","#{item_price}","#{item_amt}","#{net_amt}"]],:column_widths => {0 =>100, 1 =>180, 2=>65,3=>75, 4=>70,5 =>70}) do
            style(column(2),:align =>:right)
            style(column(3),:align =>:right)
            style(column(4),:align =>:right)
            style(column(5),:align =>:right)
          end
        }
      end
      sales_order_shipping_packages = Sales::SalesOrder.find_by_sql("select sosp.tracking_no from sales_order_shippings  sos
                                                                        inner join sales_order_shipping_packages  sosp on sos.id = sosp.sales_order_shipping_id

                                                             where sos.id = #{sales_invoice.customer_shipping_id} and sos.trans_flag = 'A'")
      shipping_amt = (nulltozero(sales_invoice.ship_amt)).to_f
      tracking="Tracking:\n"
      sales_order_shipping_packages.each do |package|
        tracking = tracking + package.tracking_no+",\n" if !package.tracking_no.blank?
      end
      pdf.font_size(10){
        pdf.table([["Shipping","#{tracking}","1","#{shipping_amt}","#{shipping_amt}","#{shipping_amt}"]],:column_widths => {0 =>100, 1 =>180, 2=>65,3=>75, 4=>70,5 =>70}) do
          style(column(2),:align =>:right)
          style(column(3),:align =>:right)
          style(column(4),:align =>:right)
          style(column(5),:align =>:right)

        end
      }
      net_amt = (nulltozero(sales_invoice.net_amt)).to_f
      item_qty = (nulltozero(sales_invoice.item_qty)).to_i
      balance=net_amt-net_amt
      pdf.table([["Payments/Credit $-#{net_amt}","Total $ #{net_amt} ","Balance Due:  $ #{balance}",]],:column_widths => {0 =>200, 1 =>180, 2=>180,},:cell_style => {:height => 25}) do
        row(0).font_style = :bold
      end
    end
  end

  def self.footer_for_sales_invoice_pdf(pdf)
    pdf.repeat :all do
      pdf.font_size(7){
        pdf.text_box "Should legal action be necessary in collection of this account, the client by receipt of merchandise assumes the payment of all court costs and attorneys fees.
A service charge of 1 1/2 % per month or 18% per annum will be assessed on the unpaid balance of any individual invoice extending beyond regular due date period.
If you have any questions regarding this invoice, please contact the accounting department at 631.694.5503.
*Cancellations will result in a forfeit of 50% of the total job invoice.", :at => [0,65]
      }
    end
    string = " <page> of <total>"
    options = { :at => [435, 790],:width => 100,:align => :right,:start_count_at => 1,}
    pdf.font_size(8){
      pdf.number_pages string, options                             #page numbering
    }
  end


  ### Sales Estimate pdf Generation Functions ###
  def self.generate_estimate_pdf_header(pdf,quotations,quotation_shippings,schema_name)
    company = Setup::Company.find_by_id(quotations[0].company_id)
    logopath = "#{Dir.getwd}/public/images/#{schema_name}/#{company.company_logo_file}"
    if !File.exists?(logopath)
      logopath = "#{Dir.getwd}/public/images/#{schema_name}/blank.jpg"
    end
    pdf.repeat :all do                                                           #start of page header
      pdf.image logopath, :width => 350, :height => 100, :position => :left

      pdf.fill_color "736F6E"                                                      #rectangle
      pdf.fill_rectangle [355,770],200,25
      pdf.stroke_color "ffffff"
      pdf.fill_color "ffffff"
      pdf.font_size(15){
        pdf. text_rendering_mode(:fill_stroke) do
          pdf.text_box " S a l e s  E s t i m a t e",:at =>[365,760],:font => "Times-Roman"                                #order header
        end
      }
      pdf.stroke_color "11111"
      pdf. fill_color "111111"
      pdf. font_size(8) {
        pdf.text_box "Page                   :", :at=>[365,730]
        pdf. text_box "Estimate #          :",:at=>[365,710]
        pdf.text_box "#{quotations[0].trans_no}",:at=>[450,710]
        pdf. text_box "Estimate Date    :",:at=>[365,690]
        pdf.text_box "#{Time.now.strftime("%b %d, %Y")}",:at=>[450,690]}
      pdf.line_width=0.5
      pdf.stroke_color "111111"
      pdf.fill_color "111111"
      pdf.stroke_rectangle [0, 660], 555, 100                          #rectangle for bill to and ship to
      pdf.stroke do
        pdf.vertical_line 560, 660, :at => 275
      end
      pdf.stroke do
        pdf.line_width=2
        pdf. horizontal_line 0, 555, :at => 540
      end
      pdf.line_width=0
      pdf. fill_color "736F6E"
      pdf.fill_rectangle [10,650],100,15                       #fill rectangle for bill to
      pdf.stroke_color "ffffff"
      pdf.fill_color "ffffff"
      pdf.font_size(10){
        pdf.text_box "Billing Address:",:at =>[15,645]

      }
      pdf.fill_color "736F6E"
      pdf.fill_rectangle [285,650],100,15                  #fill rectangle for ship to
      pdf.stroke_color "ffffff"
      pdf.fill_color "ffffff"
      pdf.font_size(10){
        pdf. text_box "Shipping Address:",:at =>[290,645]

      }
      pdf. fill_color "111111"
      pdf. stroke_color "111111"
      pdf.bounding_box([70,630],:width => 150,:height=>55) do
        pdf.font_size(8){
          pdf.text "#{ quotations[0].bill_name}"
          pdf. move_down 2
          pdf.text "#{quotations[0].bill_address1}"
          pdf.move_down 4
          pdf.text " #{quotations[0].bill_city},  #{quotations[0].bill_state},  #{quotations[0].bill_zip}, #{quotations[0].bill_country}"
        }

      end
      if !quotation_shippings.blank?
        ship_name = quotation_shippings[0].ship_name
        ship_address1 = quotation_shippings[0].ship_address1
        ship_city = quotation_shippings[0].ship_city
        ship_state = quotation_shippings[0].ship_state
        ship_zip = quotation_shippings[0].ship_zip
        ship_country = quotation_shippings[0].ship_country
      end
      pdf.bounding_box([345,630],:width => 175,:height=>55) do        
        pdf.font_size(8) {
          pdf.text "#{ ship_name}"
          pdf.move_down 2
          pdf.text "#{ ship_address1}"
          pdf.move_down 4
          pdf.text " #{ ship_city},  #{ship_state},  #{ ship_zip}, #{ship_country}"
        }
      end
    end
    return pdf
  end

  def self.generate_estimate_pdf_body(pdf,quotation_lines)
    pdf.bounding_box([0,525],:width => 600,:height=>410) do                       #table header
      #pdf.stroke_bounds
      i=0
      pdf.font_size(7)   {
        i+=1
        total_count= quotation_lines.count
        line_count=0
        quotation_lines.each do |quotation_line|                                            #table data
          line_count+=1
          pdf.text "Item                                       Description", :style => :bold
          pdf.table([["#{quotation_line.catalog_item_code}"," #{quotation_line.item_description}"]], :cell_style => {:height => 20},:column_widths => {0 => 100, 1 => 300}) do
            cells.borders = []
            row(0).borders = []
            #row(0).border_width = 2
            row(0).columns(0).font_style = :bold
            row(0).columns(0).size = 10
          end
          pdf.move_down 5
          attributes = Quotation::SalesQuotationAttributesValue.find_by_sql("select * from sales_quotation_attributes_values where sales_quotation_line_id=#{quotation_line.id} and trans_flag='A'")
          if !attributes.blank?
            pdf.text "Options",:style => :bold
            attributes.each do |attribute|
              if !attribute.catalog_attribute_value_code.blank?
                pdf.table([["#{attribute.catalog_attribute_code}","#{attribute.catalog_attribute_value_code}"]],:column_widths => {0 => 100, 1 => 200}) do
                  cells.borders = []
                  row(0).borders = []
                end
              end
            end
          end
          pdf.move_down 5
          service_and_access=Quotation::SalesQuotationLineCharge.find_by_sql("select * from sales_quotation_line_charges where  sales_quotation_line_id=#{quotation_line.id} and (item_type='S' or item_type='C') and trans_flag='A'")
          service_charge=[]
          accessories=[]

          service_and_access.each do |service_and_acc|
            if service_and_acc.item_type == 'S'
              service_charge << service_and_acc
            end
            if service_and_acc.item_type == 'C'
              accessories << service_and_acc
            end
          end
          data = item_rates(quotation_line)
          if !data.blank?
            pdf.text "Price",:style => :bold
            table_data6=[["Tier","Price","Item Amt","Service-I","Service-II","Accessories","Ship Amt*","Net Amt"]]
            pdf.font_size(8){
              pdf.table(table_data6,:cell_style => {:align=> :left,:size => 7 ,:border_width => 0.5,:font_style => :bold,:border_color => "c0c0c0"},:column_widths => {0 => 60, 1 => 60, 2 => 60, 3 => 60,4=>50,5=>80,6=>50,7=>50,8=>50,9=>50}) do
                style(column(0),:align =>:right)
                style(column(1),:align =>:right)
                style(column(2),:align =>:right)
                style(column(3),:align =>:right)
                style(column(4),:align =>:right)
                style(column(5),:align =>:right)
                style(column(6),:align =>:right)
                style(column(7),:align =>:right)
              end}
            #          data = item_rates(quotation_line)
            pdf.font_size(8){
              pdf.table(data,:cell_style => {:align=> :left,:size => 7 ,:border_width => 0.5,:border_color => "c0c0c0"},:column_widths => {0 => 60, 1 => 60, 2 => 60, 3 => 60,4=>50,5=>80,6=>50,7=>50,8=>50,9=>50}) do
                style(column(0),:align =>:right)
                style(column(1),:align =>:right)
                style(column(2),:align =>:right)
                style(column(3),:align =>:right)
                style(column(4),:align =>:right)
                style(column(5),:align =>:right)
                style(column(6),:align =>:right)
                style(column(7),:align =>:right)
              end}
          end
          pdf.move_down 5
          if  !service_charge.blank?
            pdf.text "Service Charges",:style => :bold
            table_data6=[["Item #","Qty","Price","Amount","Item Description"]]
            pdf.font_size(8){
              pdf.table(table_data6,:cell_style => {:align=> :left,:size => 7 ,:border_width => 0.5,:font_style => :bold,:border_color => "c0c0c0"},:column_widths => {0 => 100, 1 => 70, 2 => 60, 3 => 60,4=>100}) do
                style(column(0),:align =>:left)
                style(column(1),:align =>:right)
                style(column(2),:align =>:right)
                style(column(3),:align =>:right)
                style(column(4),:align =>:left)
              end}
            service_charge.each do |service|
              pdf.font_size(8){
                pdf. table([["#{service.catalog_item_code}","#{service.item_qty}","#{service.item_price}","#{service.item_amt}"," #{service.item_description}"]],:cell_style => {:align=> :left,:size => 7 ,:border_width => 0.5,:border_color => "c0c0c0"},:column_widths => {0 => 100, 1 => 70, 2 => 60, 3 => 60,4=>100}) do
                  style(column(0),:align =>:left)
                  style(column(1),:align =>:right)
                  style(column(2),:align =>:right)
                  style(column(3),:align =>:right)
                  style(column(4),:align =>:left)
                end}
            end
          end
          pdf. move_down 5
          if  !accessories.blank?
            table_data6=[["Item #","Qty","Price","Amount","Item Description"]]

            pdf.text "Accessories",:style => :bold
            pdf.font_size(8){
              pdf.table(table_data6,:cell_style => {:align=> :left,:size => 7 ,:font_style => :bold,:border_width => 0.5,:border_color => "c0c0c0"},:column_widths => {0 => 100, 1 => 70, 2 => 60, 3 => 60,4=>100}) do
                style(column(1),:align =>:right)
                style(column(2),:align =>:right)
                style(column(3),:align =>:right)
                style(column(4),:align =>:left)
              end}
            accessories.each do |accessorie|
              pdf. font_size(8){
                pdf.table([["#{accessorie.catalog_item_code}","#{accessorie.item_qty}","#{accessorie.item_price}","#{accessorie.item_amt}"," #{accessorie.item_description}"]],:cell_style => {:align=> :left,:size => 7 ,:border_width => 0.5,:border_color => "c0c0c0"},:column_widths => {0 => 100, 1 => 70, 2 => 60, 3 => 60,4=>100}) do
                  style(column(1),:align =>:right)
                  style(column(2),:align =>:right)
                  style(column(3),:align =>:right)
                  style(column(4),:align =>:left)

                end}
            end
          end

          pdf.move_down 5
          if   line_count <    total_count
            pdf.start_new_page
          end
          pdf.move_down 5
        end
      }                                                         #end of group footer
    end
  end

  def self.generate_estimate_pdf_footer(pdf)
    pdf.repeat :all do                                                    #start of page footer
      pdf.font("Helvetica",:style =>:bold)do
        pdf.font_size(7){pdf.text_box "FOR RESALE ONLY",:at=>[0,110]}
        pdf.font_size(6){
          pdf.text_box "All discrepancies must be reported within 24 hours of receipt of these goods.",:at => [0,95]

        }
        pdf.font_size(5){
          pdf.text_box "Please be aware that interest will be charged at 18% annum on all past due balances.",:at=>[0,85]}
      end
      pdf.font_size(6){

        pdf.text_box " *SHIPPING IS ONLY AN ESTIMATE
        For any product fabricated from rough diamonds mined from January 1.
        The diamonds herein invoiced have been purchased from legitimate sources not involved in funding conflict and in compliance with United Nations Resolutions. The seller hereby guarantees that these
        diamonds are conflict-free, based on personal knowledge and/or written guarantees provided by the supplier of these diamonds.

        In case the seller retains account for collection of amount due under terms of this agreement the buyer aggress to pay the actual attorney fees or reasonable collection agency fees with interest and the
        costs of the court. Net according to terms thereafter 2% monthly and 24% annually.", :at=>[0,75]
      }

    end                                                #end of page footer
    string = " <page> of <total>"
    options = { :at => [320, 730],:width => 150,:align => :right,:start_count_at => 1,}
    pdf.font_size(8){
      pdf.number_pages string, options                             #page numbering
    }
  end

  def self.item_rates(quotation_line)
    data=[]
    temp=[]
    item_tiers=Item::CatalogItem.find_by_sql("select * from catalog_items where store_code='#{quotation_line.catalog_item_code}' and trans_flag='A'")
    (1..15).each do |i|
      if quotation_line["column#{i}_quotation_flag"] =='Y'
        temp=[]
        temp << item_tiers[0]["column#{i}"]
        temp << quotation_line["column#{i}"]                   #price
        temp << quotation_line["column#{i}_amt"]               #item amount
        temp << quotation_line["setup_amt_item_dependable#{i}"]  # item dependable
        temp << quotation_line["setup_amt#{i}"]
        temp << quotation_line["accessory_amt#{i}"]
        temp << quotation_line["column#{i}_ship_amt"]
        temp << quotation_line["net_amt#{i}"]
        data << temp
      end
      i = i+1
    end
    return data
  end
end
