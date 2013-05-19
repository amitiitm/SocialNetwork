class VoiceTestimonial < ActiveRecord::Base
  belongs_to :customer, :polymorphic => true
  
  def url
    recording_settings = OPENFO['recording_servers']
    path = recording_settings['path']
    host = recording_settings['servers'][self.location]
    port = recording_settings['port']
    port = (port == "80")? "" : ":#{port}"
    "http://#{host}#{port}/#{path}/#{file}.wav"
  end
end
