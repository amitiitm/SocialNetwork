class Report::PrintReportController < ApplicationController
  require 'hpricot'
  include General
  include ClassMethods

#  def render_print_format
#    doc = Hpricot::XML(request.raw_post)
#    schema_name=session[:schema]
#    fo_name = parse_xml(doc/:rows/:report_properties/'report_format')
#    filename = "report_format#{Time.now().strftime('%d%m%y%H%M%S')}"
#    path = Setup::Type.find(:first, :conditions=>['type_cd = ? and subtype_cd = ?','UPLOAD_FOLDER','REPORT_PRINT'])
#      if path 
#        directory =  "#{Dir.getwd}" + path.value + schema_name            
#      end
#    puts filename
#    FileUtils.mkdir_p(directory)
#     absolute_filename = File.join(directory, filename)+ "." + "pdf"
#    File.open("#{Dir.getwd}/fop/xml/#{filename}.xml", 'w') {|f| f.write(doc) }
##    command = "fop -xsl #{Dir.getwd}/fop/xsl/#{fo_name}/Landscape -xml #{Dir.getwd}/fop/xml/#{filename}.xml -pdf #{Dir.getwd}/public/reports/#{filename}.pdf"
#     command = "#{Dir.getwd}/fop/fop.bat  #{Dir.getwd}/fop/xsl/#{fo_name}/Landscape  #{Dir.getwd}/fop/xml/#{filename}.xml  #{absolute_filename}"
##   "#{Dir.getwd}/fop/fop.bat"
#    puts command
#    result = system command
#    if result == true 
#      #render :text => "#{Dir.getwd}/fop/pdf/employee.pdf"
#      @result="#{filename}.pdf"
#    else
#      #render :text => 'error'
#      @result='error.pdf'
#    end
#  end

  def render_print_format
    doc = Hpricot::XML(request.raw_post) 
    doc = Zlib::Inflate.inflate(Base64.decode64((doc/"encoded")[0].inner_html))
#    doc = Hpricot::XML(doc[4..(doc.length-1)])
    doc = Hpricot::XML(doc[doc.index('<')..(doc.length-1)])
    @result = IO::FileIO.create_print_format(doc,session[:schema])
  end  
  
end
