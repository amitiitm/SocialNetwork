xml.instruct! :xml, :version=>"1.0" 
xml.users{
    xml.user do
	xml.id(@user.id)
    end
}
