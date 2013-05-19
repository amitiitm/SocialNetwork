  def destroy
    @<%= singular_name %> = <%= class_name %>.find(params[:id])
    @path = <%= plural_name %>_path
    resp @<%= singular_name %>.destroy
  end
