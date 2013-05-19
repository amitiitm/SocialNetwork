class ServersController < ApplicationController
  # GET /servers
  # GET /servers.xml
  def index
    @servers = Server.all
    resp
  end

  # GET /servers/1
  # GET /servers/1.xml
  def show
    @server = Server.find(params[:id])
    resp
  end

  # GET /servers/new
  # GET /servers/new.xml
  def new
    @server = Server.new
    @server.load_balancer = LoadBalancer.new
    resp
  end

  # GET /servers/1/edit
  def edit
    @server = Server.find(params[:id])
    if @server.server_type == 3
      unless @server.load_balancer
        @server.load_balancer = LoadBalancer.new
      end
    end
    resp
  end

  # POST /servers
  # POST /servers.xml
  def create
    @server = Server.new(params[:server])
    if @server.server_type == 3
      @server.load_balancer = LoadBalancer.new(params[:load_balancer])
    end
    if @server.save
      @errors = false
    else
      @errors = @server.errors
    end
  end

  # PUT /servers/1
  # PUT /servers/1.xml
  def update
    @server = Server.find(params[:id])
  
    if @server.update_attributes(params[:server])
      @errors = false
      if @server.server_type == 3
        if @server.load_balancer
          @server.load_balancer.update_attributes(params[:load_balancer])
        else
          @server.load_balancer = LoadBalancer.new(params[:load_balancer])
        end
      else
        if @server.load_balancer
          @server.load_balancer.destroy
        end
      end  
    else
      @errors = @server.errors
    end
  end

  # DELETE /servers/1
  # DELETE /servers/1.xml
  def destroy
    @server = Server.find(params[:id])
    @server.destroy

    respond_to do |format|
      format.html { redirect_to(servers_url) }
      format.xml  { head :ok }
    end
  end
end
