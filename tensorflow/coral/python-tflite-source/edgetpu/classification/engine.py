"""Classification Engine used for classification tasks."""
from edgetpu.basic.basic_engine import BasicEngine
import numpy
from PIL import Image


class ClassificationEngine(BasicEngine):
  """Engine used for classification task."""

  def __init__(self, model_path):
    """Creates a BasicEngine with given model.

    Args:
      model_path: String, path to TF-Lite Flatbuffer file.

    Raises:
      ValueError: An error occurred when the output format of model is invalid.
    """
    BasicEngine.__init__(self, model_path)
    output_tensors_sizes = self.get_all_output_tensors_sizes()
    if output_tensors_sizes.size != 1:
      raise ValueError(
          ('Classification model should have 1 output tensor only!'
           'This model has {}.'.format(output_tensors_sizes.size)))

  def ClassifyWithImage(
      self, img, threshold=0.1, top_k=3, resample=Image.NEAREST):
    """Classifies image with PIL image object.

    This interface assumes the loaded model is trained for image
    classification.

    Args:
      img: PIL image object.
      threshold: float, threshold to filter results.
      top_k: keep top k candidates if there are many candidates with score
        exceeds given threshold. By default we keep top 3.
      resample: An optional resampling filter on image resizing. By default it
        is PIL.Image.NEAREST. Complex filter such as PIL.Image.BICUBIC will
        bring extra latency, and slightly better accuracy.

    Returns:
      List of (int, float) which represents id and score.

    Raises:
      RuntimeError: when model isn't used for image classification.
    """
    input_tensor_shape = self.get_input_tensor_shape()
    if (input_tensor_shape.size != 4 or input_tensor_shape[3] != 3 or
        input_tensor_shape[0] != 1):
      raise RuntimeError(
          'Invalid input tensor shape! Expected: [1, height, width, 3]')
    _, height, width, _ = input_tensor_shape
    img = img.resize((width, height), resample)
    input_tensor = numpy.asarray(img).flatten()
    return self.ClassifyWithInputTensor(input_tensor, threshold, top_k)

  def ClassifyWithInputTensor(self, input_tensor, threshold=0.0, top_k=3):
    """Classifies with raw input tensor.

    This interface requires user to process input data themselves and convert
    it to formatted input tensor.

    Args:
      input_tensor: numpy.array represents the input tensor.
      threshold: float, threshold to filter results.
      top_k: keep top k candidates if there are many candidates with score
        exceeds given threshold. By default we keep top 3.

    Returns:
      List of (int, float) which represents id and score.

    Raises:
      ValueError: when input param is invalid.
    """
    if top_k <= 0:
      raise ValueError('top_k must be positive!')
    _, self._raw_result = self.RunInference(
        input_tensor)
    # top_k must be less or equal to number of possible results.
    top_k = min(top_k, len(self._raw_result))
    result = []
    indices = numpy.argpartition(self._raw_result, -top_k)[-top_k:]
    for i in indices:
      if self._raw_result[i] > threshold:
        result.append((i, self._raw_result[i]))
    result.sort(key=lambda tup: -tup[1])
    return result[:top_k]
