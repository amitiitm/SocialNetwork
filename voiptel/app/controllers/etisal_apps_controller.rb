class EtisalAppsController < ApplicationController
  def index
    @etisal_apps = EtisalApp.all
    resp
  end
  
  def show
    @etisal_app = EtisalApp.find(params[:id])
    resp
  end
  
  def new
    @etisal_app = EtisalApp.new
    resp
  end
  
  def create
    @etisal_app = EtisalApp.new(params[:etisal_app])
    @path = etisal_apps_path
    resp @etisal_app.save
  end
  
  def edit
    @etisal_app = EtisalApp.find(params[:id])
    resp
  end
  
  def update
    @etisal_app = EtisalApp.find(params[:id])
    @path = etisal_apps_path
    resp @etisal_app.update_attributes(params[:etisal_app])
  end
  
  def destroy
    @etisal_app = EtisalApp.find(params[:id])
    @path = etisal_apps_path
    resp @etisal_app.destroy
  end
end
