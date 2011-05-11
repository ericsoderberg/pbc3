#!/usr/bin/env ruby
output = %x(psql -q -t -c "select id, message_id, file_file_name from message_files" -d pbc3)
output.each_line do |line|
  next if line.length < 10
  id, message_id, file_name = line.split('|')
  id.strip!
  message_id.strip!
  file_name.strip!
  cmd = "mkdir -p #{id}"
  puts cmd
  system(cmd)
  cmd = "mv #{message_id}/#{file_name} #{id}/#{file_name}"
  puts cmd
  system(cmd)
end