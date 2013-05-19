require "net/http"
require "uri"
begin

system "cp /mnt/s3-rbi/logs/audios /mnt/amitk/infibeamdigital/s3_log_parser/s3_logs"
sleep 3
system " grep "
sleep 3
## call parser
uri = URI.parse("http://localhost:3001/main/show_blog?id=1")
sleep 2
puts Net::HTTP.get_response(uri)
puts '---------------------------------------'
puts Net::HTTP.get_response(uri)
rescue Exception => ex
  puts ex
end