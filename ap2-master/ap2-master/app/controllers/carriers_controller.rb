class CarriersController < ApplicationController
  def index
    if params[:view] == "all"
      @carriers = Carrier.find(:all, :order => "archived ASC, name ASC")
    else
      @carriers = Carrier.find(:all, :conditions => {:archived => false}, :order => "name ASC")
    end
    resp
  end

  def show
    @carrier = Carrier.find(params[:id])
    resp
  end

  def new
    @carrier = Carrier.new
    resp
  end

  def edit
    @carrier = Carrier.find(params[:id])
    resp
  end

  def create
    @carrier = Carrier.new(params[:carrier])
    @path = carriers_path
    resp(@carrier.save)
  end

  def update
    @carrier = Carrier.find(params[:id])
    @path = carriers_path
    resp @carrier.update_attributes(params[:carrier])
  end
  
  def archive
    @carrier = Carrier.find(params[:id])
    @carrier.archived = params[:carrier][:archived]
    if params[:view] == "all"
      @path = "/carriers?view=all"
    else
      @path = "/carriers"
    end
    resp @carrier.save(false)
  end

  def destroy
  end

end
