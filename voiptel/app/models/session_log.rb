class SessionLog
  
  attr_accessor :file_name
  attr_accessor :content
  
  def initialize(file_name)
    self.file_name = file_name
    self.content = ""
    file = File.open("/openfo/logs/#{file_name}")
    file.each do |line|      
      self.content += line + "<br />"
    end
  end    
end