# From: https://stackoverflow.com/questions/3781549/how-to-convert-16-bit-rgb-frame-buffer-to-a-viewable-format

TMP=/tmp/fb2jpg.jpg
INFILE=${1:-/dev/fb0}
OUTFILE=${2:-fb2jpg.pjg}

ffmpeg \
  -y -loglevel 0 \
  -vcodec rawvideo \
  -f rawvideo \
  -pix_fmt rgb565 \
  -s 240x320 \
  -i $INFILE \
  \
  -f image2 \
  -vcodec mjpeg \
  $TMP

convert -rotate "90" $TMP $OUTFILE
echo Outputted to $OUTFILE
