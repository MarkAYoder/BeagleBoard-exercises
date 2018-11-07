# From: https://stackoverflow.com/questions/3781549/how-to-convert-16-bit-rgb-frame-buffer-to-a-viewable-format

ffmpeg \
  -vcodec rawvideo \
  -f rawvideo \
  -pix_fmt rgb565 \
  -s 240x320 \
  -i test.rgb \
  \
  -f image2 \
  -vcodec mjpeg \
  test.jpg
