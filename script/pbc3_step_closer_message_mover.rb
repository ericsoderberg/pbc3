#!/usr/bin/env ruby
output = %x(psql -q -t -c "select id, audio_file_name from audios where page_id = 75" -d pbc3_development)
output.each_line do |line|
  next if line.length < 10
  id, file_name = line.split('|')
  id.strip!
  file_name.strip!
  cmd = "mkdir -p #{id}"
  puts cmd
  system(cmd)
  cmd = "cp ~/Downloads/step_closer_files/#{file_name} #{id}/#{file_name}"
  puts cmd
  system(cmd)
end