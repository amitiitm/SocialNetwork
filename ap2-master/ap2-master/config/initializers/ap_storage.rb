::STR = YAML::load(File.open("#{RAILS_ROOT}/config/ap_storage.yml"))[RAILS_ENV]["storage"]
::TMP = "/tmp"

begin
  if Folder.count == 0
    folder = Folder.new(:uuid => Guid.new.to_s)
    folder.save
  end
rescue Exception => e
  #puts e.class
end
