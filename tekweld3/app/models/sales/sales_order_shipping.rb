class Sales::SalesOrderShipping < ActiveRecord::Base
  include UserStamp
  include Dbobject
  include GenericSelects
  
  attr_accessor  :max_serial_no
  has_many :sales_order_shipping_packages, :class_name => 'Sales::SalesOrderShippingPackage',:dependent => :destroy, :extend=>ExtendAssosiation
  has_many :sales_order_shipping_truck_packages, :class_name => 'Sales::SalesOrderShippingTruckPackage',:dependent => :destroy, :extend=>ExtendAssosiation
  belongs_to :sales_order, :class_name => 'Sales::SalesOrder'
  #  validates_uniqueness_of :serial_no, :scope=>[:sales_order_id]

  def build_packaging_lines(lines_doc)
    lines_doc.each { |line_doc| add_line_details(line_doc)
    }
  end

  def add_line_details(line_doc)
    id =  parse_xml(line_doc/'id') if (line_doc/'id').first
    line = shipping_packages(line_doc.name,id) ||  shipping_truck_packages(line_doc.name,id) || nil
    line.apply_attributes(line_doc) if line
    if line.new_record?
      self.max_serial_no = line.serial_no = (self.max_serial_no.to_i + 1).to_s
    end
    line.trans_flag = 'D' if self.trans_flag == 'D'
  end

  def shipping_packages(name,id)
    sales_order_shipping_packages.find_or_build(id) if name == 'sales_order_shipping_package'
  end
  def shipping_truck_packages(name,id)
    sales_order_shipping_truck_packages.find_or_build(id) if name == 'sales_order_shipping_truck_package'
  end
  def save_lines
    sales_order_shipping_packages.save_line
    sales_order_shipping_truck_packages.save_line
  end

  def add_line_errors_to_header
    add_line_item_errors(sales_order_shipping_packages) if sales_order_shipping_packages
    add_line_item_errors(sales_order_shipping_truck_packages) if sales_order_shipping_truck_packages
  end

  def fill_default_detail_values
    #    if self.ship_date
    #      self.internal_ship_date = self.ship_date
    #    elsif(self.estimated_ship_date)
    #      self.internal_ship_date = self.estimated_ship_date
    #    end
  end
  ## function which fires email with attachment whenever ship date is changed currently not in use but if we want to send multiple ship date
  ## change alert then uncomment the the calling part in sales_order.rb. currently we r sending only single alert even if multiple ship date changes.
  def check_ship_date_change(shipping_order_line,line_doc,order,schema_name,url_with_port)
    ship_date =  parse_xml(line_doc/'ship_date') if (line_doc/'ship_date').first
    if !shipping_order_line.new_record? and (shipping_order_line.ship_date and (shipping_order_line.ship_date.to_date.strftime("%Y-%m-%d 00:00:00") != ship_date.to_date.strftime("%Y-%m-%d 00:00:00")))
      pdf_file_name_path = generate_shipdate_change_pdf(order,schema_name,url_with_port)
      email = Email::Email.send_email('SHIPDATEALERT',order)
      email.file_name_path = pdf_file_name_path
      email.save!
      activity = order.create_sales_order_transaction_activity('SHIP DATE CHANGED')
      activity.save!
    end
  end

  def generate_shipdate_change_pdf(sales_order,schema_name,url_with_port)
    order_id = sales_order.id
    path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','REPORT_PRINT'])
    if path
      directory =  "#{Dir.getwd}" + path.value + schema_name
    end
    #    image_path="http://#{request.env['HTTP_HOST']}/images/#{schema_name}/"
    image_path = "http://#{url_with_port}/images/#{schema_name}/"
    rptfile_name = Setup::Type.find(:first, :conditions=>["type_cd = 'print_format' and subtype_cd = 'shipdate_alert'"])
    filename = "#{Time.now().strftime('%Y%m%d%H%M%S')}"
    absolute_filename = File.join(directory, filename)+ "." + "pdf"
    command = "#{Dir.getwd}/fop/printformatpdf_new.bat #{Dir.getwd}/fop/#{rptfile_name.value} #{schema_name}  #{absolute_filename} #{order_id} #{image_path}"
    result = system command
    puts "****************#{result}"
    return absolute_filename
  end
end
