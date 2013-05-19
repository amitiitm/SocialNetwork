class Production::ProductionIndigoController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods
  
  def decal_imposition_inbox ## or indigo imposition
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @orders = Production::ProductionIndigoCrud.decal_imposition_inbox(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
    #    render :xml=>@orders[0].xmlcol
  end
  
  def list_decal_imposition_option_data ## or indigo imposition
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @orders = Production::ProductionIndigoCrud.list_decal_imposition_option_data(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
    #    render :xml=>@orders[0].xmlcol
  end
  
  def decal_print_inbox ## or indigo print
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @orders = Production::ProductionIndigoCrud.decal_print_inbox(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
    #    render :xml=>@orders[0].xmlcol
  end
  
  def heivelberg_cut_inbox
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)    
    @orders = Production::ProductionIndigoCrud.heivelberg_cut_inbox(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
    #    render :xml=>@orders[0].xmlcol
  end

  def view_all_indigo_print_proofs
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    url_with_port = request.host_with_port
    message,text = Production::ProductionIndigoCrud.view_all_indigo_print_proofs(doc,session[:schema],url_with_port)
    if text == 'error'
      render :xml => "<errors><error>#{message}</error></errors>"
    else
      filename = message.split('/').last
      render :xml =>"<results><result>#{filename}</result></results>"
    end
  end

  def render_indigo_print_slip 
    doc = Hpricot::XML(request.raw_post)
    indigo_code  = parse_xml(doc/:params/'indigo_code')
    schema_name = session[:schema]
    sales_order_lines = Sales::SalesOrderLine.find_by_sql ["select so.trans_no,so.ext_ref_no,so.logo_name,so.ship_date,
                                                   sol.catalog_item_code,sol.item_qty,sol.item_description,soa.artwork_file_name
                                                   from sales_order_lines sol
                                                   inner join sales_orders so on so.id = sol.sales_order_id
                                                   inner join sales_order_artworks soa on soa.sales_order_id = so.id
                                                   where soa.final_artwork_flag = 'Y' and sol.item_type = 'I' and sol.trans_flag = 'A' and indigo_code = ?",indigo_code]
    pdf = Prawn::Document.new
    #    pdf = Prawn::Document.new(:page_size => "A4", :page_layout => :landscape)
    sales_order_lines_count = sales_order_lines.size
    i = 1
    sales_order_lines.each do |sales_order_line|
      ship_date = sales_order_line.ship_date.to_date if sales_order_line.ship_date
      table_data1 = [["Order# : ","#{sales_order_line.trans_no}"],
        ["Customer PO# : ","#{sales_order_line.ext_ref_no}"],
        ["Logo : ","#{sales_order_line.logo_name}"],
        ["Ship Date :","#{ship_date}"],
        ["Item :","#{sales_order_line.catalog_item_code}"],
        ["Quantity :","#{sales_order_line.item_qty.to_i}"]       
      ]
      y = 680
      pdf.bounding_box([0,y],:width => 600) do
        pdf.text_box("INDIGO PRINT SLIP",:align => :center,:style =>:bold)
      end
      ## newly added for barcode generation
      y = y - 50
      pdf.bounding_box [10,y], :width => 200 do
        file = "C:/Windows/fonts/I2OF5TXT.ttf"
        pdf.font_families["I2OF5"] = {:normal => { :file => file }
        }
        pdf.table([["#{sales_order_line.trans_no}"]],:cell_style => {:width => 120,:align=> :left,:size => 35, :border_color => 'FFFFFF',:font => "I2OF5"}) do
        end
      end
      logopath = "#{Dir.getwd}/public/attachments/#{schema_name}/#{sales_order_line.artwork_file_name}"
      if !File.exists?(logopath)
        logopath = "#{Dir.getwd}/public/images/#{schema_name}/blank.jpg"
      end
      pdf.bounding_box [300,615], :width=>150, :height =>100 do
        pdf.image logopath, :position => :left
      end
      y = y - 20
      pdf.bounding_box([10,y],:width => 500) do
        pdf.table(table_data1, :cell_style => {:width => 120,:align=> :left,:size => 10 , :border_color => 'FFFFFF'},:column_widths => {0 =>100, 1 => 180}) do
          style(column(0),:font_style =>:bold)
        end
        pdf.table([["Item Description :","#{sales_order_line.item_description}"]], :cell_style => {:width => 120,:align=> :left,:size => 10 , :border_color => 'FFFFFF'},:column_widths => {0 =>100, 1 =>375}) do
          style(column(0),:font_style =>:bold)
        end
      end
      pdf.start_new_page if sales_order_lines_count != i
      i = i + 1
    end
    path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','REPORT_PRINT'])
    if path
      directory =  "#{Dir.getwd}" + path.value + schema_name
    end
    filename = "#{Time.now().strftime('%Y%m%d%H%M%S')}"
    absolute_filename = File.join(directory, filename)+ "." + "pdf"
    pdf.render_file "#{absolute_filename}"
    render :xml =>"<url><result>#{filename}.pdf</result></url>"
  end
end
