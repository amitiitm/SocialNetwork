#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "production"
require File.dirname(__FILE__) + "/../../config/environment"

$running = true
Signal.trap("TERM") do 
  $running = false
end

update = JobUpdate.find(:first, :conditions => {:key => "update_cached_stuff"}) || JobUpdate.new(:key => "update_cached_stuff")

while($running) do  
  
  Cdr.find_with_out_stats.each do |cdr|
    cdr.update_cached_stuff
    ActiveRecord::Base.logger.info {"Update Cached for CDR #{cdr.id}"}
    puts "Update Cached for CDR #{cdr.id}"
  end
  update.updated_at = Time.now
  update.save
	seconds = CachedApDailyCdr.duration_on(Time.now)

  Rails.cache.write('seconds', seconds)
  sleep (5 * 60)
end
