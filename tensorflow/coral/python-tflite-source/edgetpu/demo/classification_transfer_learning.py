# python3
r"""A demo to demonstrate transfer learning for classification model.

Args:
  - extractor
    Path of embedding extractor, by default it will specify
    'mobilenet_v1_1.0_224_quant_embedding_extractor_edgetpu.tflite' under
    test_data/imprinting.

  - data
    Path to the directory of data set. By default it is pointing to
    'test_data/open_image_v4_subset'. Please notice that you need to run
    'test_data/download_imprinting_test_data.sh' to generate the data set.

  - output
    Output name of the trained model. By default it is
    '[extarctor_name]_retrained.tflite'.

  - test_ratio
    The ratio of images used for test. By default it's 0.25.

Steps:
  - Prepares the data set for transfer learning.
    Run 'bash test_data/download_imprinting_test_data.sh' to download the data
    we prepared. There are 10 categories, 20 images for each category. 200
    images in total.

  - Run this demo to create the new classification model.
    python3.5 classification_transfer_learning.py --output='my_model.tflite'

  - Verify with Classification model.
    'my_model.tflite' and 'my_model.txt'(labels file) produced by last step can
    be treated as same as a normal classification model. You can use
    ClassificationEngine for verification or further development.
    python3.5 classify_image.py --model='my_model.tflite' \
      --label='my_model.txt' --image='../test_data/cat.bmp'
"""
import argparse
import os
from edgetpu.basic.basic_engine import BasicEngine
from edgetpu.classification.engine import ClassificationEngine
from edgetpu.learn.imprinting.engine import ImprintingEngine
import numpy as np
from PIL import Image


def _ReadData(path, test_ratio):
  """Parses data from given directory, split them into two sets.

  Args:
    path: string, path of the data set. Images are stored in sub-directory
      named by category.
    test_ratio: float in (0,1), ratio of data used for testing.

  Returns:
    (train_set, test_set), A tuple of two dicts. Keys are the categories and
      values are lists of image file names.
  """
  train_set = {}
  test_set = {}
  for category in os.listdir(path):
    category_dir = os.path.join(path, category)
    if os.path.isdir(category_dir):
      images = [f for f in os.listdir(category_dir)
                if os.path.isfile(os.path.join(category_dir, f))]
      if images:
        k = int(test_ratio * len(images))
        test_set[category] = images[:k]
        assert test_set[category], 'No images to test [{}]'.format(category)
        train_set[category] = images[k:]
        assert train_set[category], 'No images to train [{}]'.format(category)
  return train_set, test_set


def _PrepareImages(image_list, directory, shape):
  """Reads images and converts them to numpy array with given shape.

  Args:
    image_list: a list of strings storing file names.
    directory: string, path of directory storing input images.
    shape: a 2-D tuple represents the shape of required input tensor.

  Returns:
    A list of numpy.array.
  """
  ret = []
  for filename in image_list:
    with Image.open(os.path.join(directory, filename)) as img:
      img = img.resize(shape, Image.NEAREST)
      ret.append(np.asarray(img).flatten())
  return np.array(ret)


def _SaveLabels(labels, model_path):
  """Output labels as a txt file.

  Args:
    labels: {int : string}, map between label id and label.
    model_path: string, path of the model.
  """
  label_file_name = model_path.replace('.tflite', '.txt')
  with open(label_file_name, 'w') as f:
    for label_id, label in labels.items():
      f.write(str(label_id) + '  ' + label + '\n')
  print('Labels file saved as :', label_file_name)


def _GetRequiredShape(model_path):
  """Gets image shape required by model.

  Args:
    model_path: string, path of the model.

  Returns:
    (width, height).
  """
  tmp = BasicEngine(model_path)
  input_tensor = tmp.get_input_tensor_shape()
  return (input_tensor[2], input_tensor[1])


def _ParseArgs():
  """Parses args, set default values if it's not passed.

  Returns:
    Object with attributes. Each attribute represents an argument.
  """
  print('----------------------      Args    ----------------------')
  parser = argparse.ArgumentParser()
  parser.add_argument(
      '--extractor', help='Path to the embedding extractor.')
  parser.add_argument(
      '--data', help='Path to the training set, images are stored under sub-directory named by category.')  # pylint: disable=line-too-long
  parser.add_argument(
      '--output', help='Name of the trained model.')
  parser.add_argument(
      '--test_ratio', type=float,
      help='float number in (0,1), ratio of data used for test data.')
  args = parser.parse_args()
  curr_path = os.path.dirname(os.path.realpath(__file__))
  if not args.extractor:
    args.extractor = os.path.join(curr_path, '../test_data/imprinting/mobilenet_v1_1.0_224_quant_embedding_extractor_edgetpu.tflite')  # pylint: disable=line-too-long
  print('Embedding extractor :', args.extractor)
  if not args.data:
    args.data = os.path.join(curr_path, '../test_data/open_image_v4_subset')
  print('Data set :', args.data)
  if not args.output:
    model_name = os.path.basename(args.extractor)
    args.output = model_name.replace('.tflite', '_retrained.tflite')
  print('Output path :', args.output)
  # By default, choose 25% data for test.
  if not args.test_ratio:
    args.test_ratio = 0.25
  assert args.test_ratio > 0
  assert args.test_ratio < 1.0
  print('Ratio of test images: {:.0%}'.format(args.test_ratio))
  return args


def main():
  args = _ParseArgs()
  print('---------------      Parsing data set    -----------------')
  print('Dataset path:', args.data)

  train_set, test_set = _ReadData(args.data, args.test_ratio)
  print('Image list successfully parsed! Category Num = ', len(train_set))
  shape = _GetRequiredShape(args.extractor)

  print('---------------- Processing training data ----------------')
  print('This process may take more than 30 seconds.')
  train_input = {}
  for category, image_list in train_set.items():
    print('Processing category:', category)
    train_input[category] = _PrepareImages(
        image_list, os.path.join(args.data, category), shape)

  print('----------------      Start training     -----------------')
  engine = ImprintingEngine(args.extractor)
  labels_map = engine.TrainAll(train_input)
  print('----------------     Training finished!  -----------------')

  engine.SaveModel(args.output)
  print('Model saved as : ', args.output)
  _SaveLabels(labels_map, args.output)

  print('------------------   Start evaluating   ------------------')
  engine = ClassificationEngine(args.output)
  top_k = 5
  correct = [0] * top_k
  wrong = [0] * top_k
  for category, image_list in test_set.items():
    print('Evaluating category [', category, ']')
    for img_name in image_list:
      img = Image.open(os.path.join(args.data, category, img_name))
      candidates = engine.ClassifyWithImage(img, threshold=0.1, top_k=top_k)
      recognized = False
      for i in range(top_k):
        if i < len(candidates) and labels_map[candidates[i][0]] == category:
          recognized = True
        if recognized:
          correct[i] = correct[i] + 1
        else:
          wrong[i] = wrong[i] + 1
  print('----------------     Evaluation result   -----------------')
  for i in range(top_k):
    print('Top {} : {:.0%}'.format(i+1, correct[i] / (correct[i] + wrong[i])))


if __name__ == '__main__':
  main()
