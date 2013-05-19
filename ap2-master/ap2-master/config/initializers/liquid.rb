Dir.glob(File.join(RAILS_ROOT, "/app/liquid/*.rb")).each do |l|
  require l
end