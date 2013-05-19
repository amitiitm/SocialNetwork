class Production::ProductionReportController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods

  def list_production_stages
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc)
    @orders = Production::ProductionReport.list_production_stages(doc)
    #    render :xml=>@orders[0].xmlcol 
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
  end

  def render_packaging_job_format  ### used to print pick slip
    doc = Hpricot::XML(request.raw_post)
    id  = parse_xml(doc/:params/'id')
    id_flag  = parse_xml(doc/:params/'id_flag')
    ## these changes are done bcos print service is calling from list and inbox screen from list we get order_id and from inbox we get order_line_id
    if id_flag == 'O'
      sales_order = Sales::SalesOrder.active.find_by_id(id)
      sales_order_attr = Sales::SalesOrderAttributesValue.active.find_all_by_sales_order_id(sales_order.id)
      sales_order_lines = Sales::SalesOrderLine.active.find_all_by_sales_order_id(sales_order.id)
    elsif id_flag == 'L'
      sales_order_lines = Sales::SalesOrderLine.active.find_all_by_id(id)
      sales_order = Sales::SalesOrder.active.find_by_id(sales_order_lines[0].sales_order_id)
      sales_order_attr = Sales::SalesOrderAttributesValue.active.find_all_by_sales_order_id(sales_order_lines[0].sales_order_id)
    elsif id_flag == 'S'
      shiping = Sales::SalesOrderShipping.active.find_by_id(id)
      sales_order = Sales::SalesOrder.active.find_by_id(shiping.sales_order_id)
      sales_order_attr = Sales::SalesOrderAttributesValue.active.find_all_by_sales_order_id(shiping.sales_order_id)
      sales_order_lines = Sales::SalesOrderLine.active.find_all_by_sales_order_id(shiping.sales_order_id)
    end
    schema_name = session[:schema]
    pdf = Prawn::Document.new
    pdf.font "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"
    sales_order_line = Sales::SalesOrderLine.active.find_by_sales_order_id_and_item_type_and_line_type(sales_order.id,'I','M')
    catalog_item = Item::CatalogItem.find_by_id(sales_order_line.catalog_item_id)
    logopath = "#{Dir.getwd}/public/images/#{schema_name}/#{catalog_item.image_thumnail}"
    if !File.exists?(logopath)
      logopath = "#{Dir.getwd}/public/images/#{schema_name}/blank.jpg"
    end
    logopath = "#{Dir.getwd}/public/images/#{schema_name}/blank.jpg" if catalog_item.image_thumnail.blank?
    pdf.font("Times-Roman",:style => :bold) do
      pdf.font_size(12){pdf.text_box "Pick slip" ,:at=>[200,700]}
    end
    pdf.bounding_box [300,635], :width => 500,:height => 80 do
      file = "C:/Windows/fonts/I2OF5TXT.ttf"
      pdf.font_families["I2OF5"] = {:normal => { :file => file }}
      pdf.table([["#{sales_order.trans_no}"]],:cell_style => {:width => 500,:height => 80,:align=> :left,:size => 35, :border_color => 'FFFFFF',:font => "I2OF5"})
    end
    pdf.bounding_box [300,615], :width=>150, :height =>100 do
      pdf.image logopath, :width => 150, :height => 100, :position => :left
    end
    pdf.font("Times-Roman",:style=>:bold) do
      pdf.bounding_box [0,625], :width=>250, :height =>80 do
        pdf.font_size(10){
          pdf.text_box "Job#" ,:at=>[0,80]
          pdf.text_box "Customer Po #",:at=>[0,60]
          pdf.text_box "ship Date:",:at=>[0,40]
          pdf.text_box "Ship Method:",:at=>[0,20]}
      end
    end
    pdf.font("Times-Roman") do
      pdf.bounding_box [90,625], :width=>200, :height =>80 do
        pdf.font_size(10){
          pdf.text_box "#{sales_order.trans_no}" ,:at=>[0,80]

          pdf.text_box "#{sales_order.ext_ref_no}" ,:at=>[0,60]

          pdf.text_box "#{sales_order.ship_date.to_date.strftime('%m/%d/%Y')}",:at=>[0,40] if sales_order.ship_date
          pdf.text_box "#{sales_order.ship_method}", :at=>[0,20]
        }
      end
    end
    data_line=[]
    sales_order_attr.each do |soav|
      data=[]
      if soav.catalog_attribute_value_code != ''
        data << soav.catalog_attribute_code
        data << soav.catalog_attribute_value_code
        data_line << data
      end

    end
    if data_line.count >0
      pdf.font("Times-Roman",:style=>:bold) do
        pdf.font_size(8){
          pdf.table(data_line,:cell_style => {:overflow => :shrink_to_fit, :font => "Times-Roman",:height=>20},:column_widths => {0 => 70, 1 => 200}) do
            #       pdf.table(data_line,:cell_style => {:font => "Times-Roman",:height=>20},:column_widths => {0 => 70, 1 => 200, 2 => 135, 3 => 135 }) do
            style(column(0),:font_style=>:bold)
            row(0).border_width = 0.5

            cells.borders = []
            row(0).borders = [:top,:bottom,:left,:right]
            row(0).border_width = 0.5
            #row(0).font_style = :bold
            columns(0..1).borders = []
            row(0).columns(0..1).borders = []
          end
        }
      end
    end
    pdf.move_down 50
    pdf.font("Helvetica",:style =>:bold)do
      pdf.font_size(12){pdf.text "Customer Message"}
    end
    pdf. move_down 10
    pdf.stroke_color "d5d5d5"

    data=[["#{sales_order.special_instructions}"]]
    pdf.font_size(10){
      pdf.table(data,:cell_style => {:font => "Times-Roman",:border_color => "d5d5d5",:height => 50},:column_widths => {0 =>540 }) do
        row(0).border_width = 1
      end
    }
    pdf.move_down 5
    pdf.font_size(10){
      data=[["Quantity","Item","warehouse","Location"]]
      pdf.table(data,:cell_style => {:font => "Times-Roman",:border_color => "d5d5d5", :font_style => :bold,:height => 20},:column_widths => {0 => 70, 1 => 200, 2 => 135, 3 => 135 }) do
        row(0).border_width = 0.5
      end}

    order_line=[]
    sales_order_lines.each do |sol|
      if sol.item_type != 'S'
        data_item=[]
        data_item << sol.item_qty
        data_item << sol.catalog_item_code
        data_item<< "NA"
        data_item << "AC1"
        order_line << data_item
      end
    end
    lastborder = sales_order_lines.count
    pdf.font_size(8){
      pdf.table(order_line,:cell_style => {:font => "Times-Roman",:border_color => "d5d5d5"},:column_widths => {0 => 70, 1 => 200, 2 => 135, 3 => 135}) do
        row(0..lastborder-1).border_width = 0.5
        cells.borders = []
        row(0).borders = [:top,:bottom,:left,:right]
        row(0..lastborder-1).columns(0..4).borders = [:left,:right]
        row(lastborder-1).borders = [:left,:right,:bottom]
      end
    }
    activity_message = Artwork::ArtworkCrud.create_activity_message(sales_order,'PICKSLIP PRINTED')
    activity = sales_order.create_sales_order_transaction_activity(activity_message)
    activity.save!
    path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','REPORT_PRINT'])
    if path
      directory =  "#{Dir.getwd}" + path.value + schema_name
    end
    filename = "#{Time.now().strftime('%Y%m%d%H%M%S')}"
    absolute_filename = File.join(directory, filename)+ "." + "pdf"
    pdf.render_file "#{absolute_filename}"
    render :xml =>"<url><result>#{filename}.pdf</result></url>"
  end





  #  def render_packaging_job_format ### this is using report commander we r printing from PRAWN
  #    doc = Hpricot::XML(request.raw_post)
  #    shipping_id  = parse_xml(doc/:params/'id')
  #    date_format = 'mm/dd/yyyy'
  #    schema_name = session[:schema]
  #    path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','REPORT_PRINT'])
  #    if path
  #      directory =  "#{Dir.getwd}" + path.value + schema_name
  #    end
  #    image_path="http://#{request.env['HTTP_HOST']}/attachments/#{schema_name}/"
  #    filename = "#{Time.now().strftime('%Y%m%d%H%M%S')}"
  #    absolute_filename = File.join(directory, filename)+ "." + "pdf"
  #    rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'pick_prod_job'"])
  #    command = "#{Dir.getwd}/fop/printformatpdf_new.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{shipping_id} #{image_path}"
  #    result = system command
  #    if result == true
  #      @result="#{filename}.pdf"
  #    else
  #      @result='error.pdf'
  #    end
  #    render :template => "report/print_report/render_print_format"
  #  end

  def render_package_slip_format ## this print service generates package slip pdf using PRAWN
    doc = Hpricot::XML(request.raw_post)
    ship_id  = parse_xml(doc/:params/'id')
    schema_name = session[:schema]
    shipping = Sales::SalesOrderShipping.active.find_by_id(ship_id)
    pdf = Prawn::Document.new
    sales_order = Sales::SalesOrder.active.find_by_id(shipping.sales_order_id)
    order_line = Sales::SalesOrderLine.active.find_by_sales_order_id_and_item_type(shipping.sales_order_id,'I')
    packing_lines = Sales::SalesOrderShippingPackage.active.find_all_by_sales_order_shipping_id(ship_id)
    packing_lines_count = packing_lines.size
    i = 1
    packing_lines.each do |packing_line|
      table_data1 = [["Order# : ","#{sales_order.trans_no}"],
        ["Customer PO# : ","#{sales_order.ext_ref_no}"],
        ["Logo : ","#{sales_order.logo_name}"],
        ["Case : ","Box #{i} of #{packing_lines_count}"],
        ["Item :","#{order_line.catalog_item_code}"],
        ["Quantity :","#{packing_line.pcs_per_carton.to_i}"],
        ["Box Size : ","#{packing_line.carton_length}x#{packing_line.carton_width}x#{packing_line.carton_height}"],
        ["Weight","#{packing_line.carton_wt}"]

      ]
      y = 680
      pdf.bounding_box([0,y],:width => 600) do
        pdf.text_box("Package Slip",:align => :center,:style =>:bold)
      end
      ## newly added for barcode generation
      y = y - 50
      pdf.bounding_box [10,y], :width => 200 do
        file = "C:/Windows/fonts/I2OF5TXT.ttf"
        pdf.font_families["I2OF5"] = {:normal => { :file => file }
        }
        pdf.table([["#{sales_order.trans_no}"]],:cell_style => {:width => 120,:align=> :left,:size => 35, :border_color => 'FFFFFF',:font => "I2OF5"}) do
        end
      end

      y = y - 20
      pdf.bounding_box([10,y],:width => 300) do
        pdf.table(table_data1, :cell_style => {:width => 120,:align=> :left,:size => 10, :border_color => 'FFFFFF'}) do
          style(column(0),:font_style =>:bold)
        end
      end
      ### newly added to show special instructions
      y = y - 200
      if (sales_order.special_instructions and sales_order.special_instructions != '')
        pdf.bounding_box([10,y],:width => 500) do
          pdf.table([['Customer Message']], :cell_style => {:width => 500,:align=> :left,:size => 10,:border_width => 0,:border_color => 'FFFFFF'}) do
            style(column(0),:font_style =>:bold)
          end
        end
        y = y-20
        pdf.bounding_box([10,y],:width => 500) do
          table_data2 = [["#{sales_order.special_instructions}"]]
          pdf.table(table_data2, :cell_style => {:width => 500,:align=> :left,:size => 10,:border_width => 0.2}) do
            style(column(0))
          end
        end
      end
      pdf.start_new_page if packing_lines_count != i
      i = i + 1
    end
    activity_message = Artwork::ArtworkCrud.create_activity_message(sales_order,'PACKAGESLIP PRINTED')
    activity = sales_order.create_sales_order_transaction_activity(activity_message)
    activity.save!
    path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','REPORT_PRINT'])
    if path
      directory =  "#{Dir.getwd}" + path.value + schema_name
    end
    filename = "#{Time.now().strftime('%Y%m%d%H%M%S')}"
    absolute_filename = File.join(directory, filename)+ "." + "pdf"
    pdf.render_file "#{absolute_filename}"
    render :xml =>"<url><result>#{filename}.pdf</result></url>"
  end

  #  def render_package_slip_format ## this print service generates pdf using report commander
  #    doc = Hpricot::XML(request.raw_post)
  #    shipping_id  = parse_xml(doc/:params/'id')
  #    date_format = 'mm/dd/yyyy'
  #    schema_name = session[:schema]
  #    path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','REPORT_PRINT'])
  #    if path
  #      directory =  "#{Dir.getwd}" + path.value + schema_name
  #    end
  #    image_path="http://#{request.env['HTTP_HOST']}/attachments/#{schema_name}/"
  #    filename = "#{Time.now().strftime('%Y%m%d%H%M%S')}"
  #    absolute_filename = File.join(directory, filename)+ "." + "pdf"
  #    rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'package_slip_format'"])
  #    command = "#{Dir.getwd}/fop/printformatpdf_new.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{shipping_id} #{image_path}"
  #    result = system command
  #    if result == true
  #      @result="#{filename}.pdf"
  #    else
  #      @result='error.pdf'
  #    end
  #    render :template => "report/print_report/render_print_format"
  #  end
  def list_production_plan_sheet
    doc = Hpricot::XML(request.raw_post)
    doc = doc.to_s.gsub("&amp;","&")
    doc = Hpricot::XML(doc)
    #    @orderreceive,@orderentry,@orderqc,@artworkreceive,@artworkreviewed,@artworkapprovedbycust,@accountreviewed,@paperproof = Production::ProductionReport.list_production_plan_sheet(doc)
    @orders = Production::ProductionReport.list_production_plan_sheet(doc)
    render :xml=>'<encoded>'+Base64.encode64(Zlib::Deflate.deflate(@orders[0].xmlcol))+'</encoded>'
  end
end


