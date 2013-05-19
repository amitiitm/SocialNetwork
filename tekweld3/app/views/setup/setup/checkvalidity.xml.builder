xml.instruct! :xml, :version=>"1.0"
xml.results{
  xml.result do
   l = @field2
    xml.valid('Y') if @result[0]
    xml.data_value(@result[0][l]) if @result[0]
    xml.valid('N') if !@result[0]
  end
}
