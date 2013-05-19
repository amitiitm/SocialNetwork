class FilesController < ApplicationController
  skip_filter :login_required
  
  def create
    @success = false
    file_data = params[:Filedata]
    file_name = params[:Filename]
    logger.info { "filename: #{file_name} path: #{file_data.original_filename} filedata: #{file_data}" }
    @file = MyFile.new(:tmp_location => file_data.path, :name => file_name)

    if @file.save
      @success = true           
    else
      logger.info { "----------- ERROR SAVING FILE!" }
      logger.info { @file.errors.full_messages.join("\n") }
    end
    
    render :layout => false    
  end
  
  def show
    file = MyFile.find(params[:id])
    send_file(File.join(STR, file.folder.uuid, "#{file.uuid}.file"), :filename => file.name)
  end
  
  def destroy
    @file = MyFile.find(params[:id]).destroy()
    
    respond_to do |wants|
      wants.js { render :layout => false, :template => "files/destroy.json.erb" }
    end    
  end
end
