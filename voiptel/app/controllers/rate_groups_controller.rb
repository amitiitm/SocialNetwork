class RateGroupsController < ApplicationController
  def index
    @rate_groups = RateGroup.all
  end
  
  def create
    @rate_group = RateGroup.new(params[:rate_group])
    if @rate_group.save
      @error = false
    else
      @error = @rate_group.errors.full_messages.join("\n")
    end        
  end
end
