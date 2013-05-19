xml.instruct! :xml, :version=>"1.0"
#
#xml.results{
#  @labels.each{|label|
#    xml.result(label+'.html')
#  }
#}


xml.results{
    xml.result(@message)
}