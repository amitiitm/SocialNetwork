#begin
#  aFile = File.new("D:/file_handling1.txt", "r+")
#  if aFile
#    content = aFile.sysread(21)
#    puts content
#  else
#    puts "Unable to open file!"
#  end
#rescue Exception => ex
#  puts ex
#  retry
#end


#aFile = File.new("D:/file_handling.txt", "a+")
#if aFile
#   content = aFile.syswrite("file updated using syswrite")
#   puts File.size?("D:/gwl-indb.jpg")
#   p File::ftype( "D:/" )
#   puts content
#else
#   puts "Unable to open file!"
#end
begin
  raise 'A test exception.'
rescue Exception => e
  puts e
ensure
  puts "Defi netely run"
end  