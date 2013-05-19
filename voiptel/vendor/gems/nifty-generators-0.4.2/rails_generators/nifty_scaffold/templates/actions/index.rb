  def index
    @<%= plural_name %> = <%= class_name %>.all
    resp
  end
