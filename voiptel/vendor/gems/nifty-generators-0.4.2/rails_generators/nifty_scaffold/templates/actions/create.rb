  def create
    @<%= singular_name %> = <%= class_name %>.new(params[:<%= singular_name %>])
    @path = <%= plural_name %>_path
    resp @<%= singular_name %>.save
  end
