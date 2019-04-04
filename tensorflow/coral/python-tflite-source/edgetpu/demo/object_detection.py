"""A demo for object detection.

For Raspberry Pi, you need to install 'feh' as image viewer:
sudo apt-get install feh

Example (Running under python-tflite-source/edgetpu directory):

  - Face detection:
    python3.5 demo/object_detection.py \
    --model='test_data/mobilenet_ssd_v2_face_quant_postprocess_edgetpu.tflite' \
    --input='test_data/face.jpg'

  - Pet detection:
    python3.5 demo/object_detection.py \
    --model='test_data/ssd_mobilenet_v1_fine_tuned_edgetpu.tflite' \
    --label='test_data/pet_labels.txt' \
    --input='test_data/pets.jpg'

'--output' is an optional flag to specify file name of output image.
"""
import argparse
import platform
import subprocess
from edgetpu.detection.engine import DetectionEngine
from PIL import Image
from PIL import ImageDraw


# Function to read labels from text files.
def ReadLabelFile(file_path):
  with open(file_path, 'r') as f:
    lines = f.readlines()
  ret = {}
  for line in lines:
    pair = line.strip().split(maxsplit=1)
    ret[int(pair[0])] = pair[1].strip()
  return ret


def main():
  parser = argparse.ArgumentParser()
  parser.add_argument(
      '--model', help='Path of the detection model.', required=True)
  parser.add_argument(
      '--label', help='Path of the labels file.')
  parser.add_argument(
      '--input', help='File path of the input image.', required=True)
  parser.add_argument(
      '--output', help='File path of the output image.')
  args = parser.parse_args()

  if not args.output:
    output_name = 'object_detection_result.jpg'
  else:
    output_name = args.output

  # Initialize engine.
  engine = DetectionEngine(args.model)
  labels = ReadLabelFile(args.label) if args.label else None

  # Open image.
  img = Image.open(args.input)
  draw = ImageDraw.Draw(img)

  # Run inference.
  ans = engine.DetectWithImage(img, threshold=0.05, keep_aspect_ratio=True,
                               relative_coord=False, top_k=10)

  # Display result.
  if ans:
    for obj in ans:
      print ('-----------------------------------------')
      if labels:
        print(labels[obj.label_id])
      print ('score = ', obj.score)
      box = obj.bounding_box.flatten().tolist()
      print ('box = ', box)
      # Draw a rectangle.
      draw.rectangle(box, outline='red')
    img.save(output_name)
    if platform.machine() == 'x86_64':
      # For gLinux, simply show the image.
      img.show()
    elif platform.machine() == 'armv7l':
      # For Raspberry Pi, you need to install 'feh' to display image.
      subprocess.Popen(['feh', output_name])
    else:
      print ('Please check ', output_name)
  else:
    print ('No object detected!')

if __name__ == '__main__':
  main()
