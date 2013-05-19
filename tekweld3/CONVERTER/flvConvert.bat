cd CONVERTER

ffmpeg -i %1 -ar 44100 -b 256k  -r 30 -y %2