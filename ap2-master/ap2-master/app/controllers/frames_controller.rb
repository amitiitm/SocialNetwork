class FramesController < ApplicationController
  layout "frame"
  def call_monitor
    call_monitor_frame
    @client_calls = params[:calls]
    @client_channels = params[:channels]
    @client_seconds = params[:seconds]
    logger.info { "calls_client: #{@client_calls} cache: #{@calls} | channels_client: #{@client_channels} cache: #{@channels}" }
  end
  
  def call_monitor_frame
    @calls = Rails.cache.read("calls")
		@channels = Rails.cache.read("channels")
		@seconds = Rails.cache.read("monitor_seconds")
  end

end
