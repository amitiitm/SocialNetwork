  def new
    @<%= singular_name %> = <%= class_name %>.new
    resp
  end
