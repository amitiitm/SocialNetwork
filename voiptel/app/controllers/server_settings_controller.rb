class ServerSettingsController < ApplicationController

  # GET /server_settings
  # GET /server_settings.xml
  def index
    @server_settings = ServerSetting.all

    resp
  end

  # GET /server_settings/1
  # GET /server_settings/1.xml
  def show
    @server_setting = ServerSetting.find(params[:id])

    resp
  end

  # GET /server_settings/new
  # GET /server_settings/new.xml
  def new
    @server_setting = ServerSetting.new
    resp
  end

  # GET /server_settings/1/edit
  def edit
    @server_setting = ServerSetting.find(params[:id])
    resp
  end

  # POST /server_settings
  # POST /server_settings.xml
  def create
    @server_setting = ServerSetting.new(params[:server_setting])

    respond_to do |format|
      if @server_setting.save
        flash[:notice] = 'ServerSetting was successfully created.'
        format.html { redirect_to(server_settings_path) }
        format.xml  { render :xml => @server_setting, :status => :created, :location => @server_setting }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @server_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /server_settings/1
  # PUT /server_settings/1.xml
  def update
    @server_setting = ServerSetting.find(params[:id])

    respond_to do |format|
      if @server_setting.update_attributes(params[:server_setting])
        flash[:notice] = 'ServerSetting was successfully updated.'
        format.html { redirect_to(server_settings_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @server_setting.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /server_settings/1
  # DELETE /server_settings/1.xml
  def destroy
    @server_setting = ServerSetting.find(params[:id])
    @server_setting.destroy

    respond_to do |format|
      format.html { redirect_to(server_settings_url) }
      format.xml  { head :ok }
    end
  end
end
