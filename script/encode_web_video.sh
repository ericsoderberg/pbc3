#!/bin/bash
#
# encode video for PBC web site
#

input_file=$(basename "$1")
name="${input_file%.*}"

# https://www.virag.si/2012/01/web-video-encoding-tutorial-with-ffmpeg-0-9/
ffmpeg -i $1 -vcodec libx264 -profile:v main -preset slow -b:v 500k -maxrate 500k -bufsize 1000k -vf scale=850:480 -threads 0 -acodec libfaac -b:a 128k ${name}.mp4

# https://www.virag.si/2012/01/webm-web-video-encoding-tutorial-with-ffmpeg-0-9/
ffmpeg -i $1 -codec:v libvpx -quality good -cpu-used 0 -b:v 600k -maxrate 600k -bufsize 1200k -qmin 10 -qmax 42 -vf scale=850:480 -threads 4 -codec:a libvorbis -b:a 128k ${name}.webm