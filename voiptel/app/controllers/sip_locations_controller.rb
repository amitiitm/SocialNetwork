class SipLocationsController < ApplicationController
  def index
    @locations = SipLocation.all
    
    resp
  end

end
