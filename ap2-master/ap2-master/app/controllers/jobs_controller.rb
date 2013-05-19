class JobsController < ApplicationController
  def logger    
  end
  
  def has_job
    Rails.logger.silence do
      #jobs = Rails.cache.read("active_jobs")
      jobs = ActiveJobs.find(:all, :conditions => {:state => 1})
      render :layout => false, :text => {:has_job => (jobs.size > 0)}.to_json
    end
  end
  
  def index
    Rails.logger.silence do
      jobs = ActiveJobs.find(:all, :conditions => {:state => 1}, :select => "id")    
      respond_to do |format|
        format.js {render :layout => nil, :text => jobs.to_json}
      end
    end
  end
  
  def show
    Rails.logger.silence do
      #sleep 0.5
      job = ActiveJobs.find(params[:id])    
      respond_to do |format|
        format.js {render :layout => nil, :text => job.to_json}
      end
    end
  end
end
