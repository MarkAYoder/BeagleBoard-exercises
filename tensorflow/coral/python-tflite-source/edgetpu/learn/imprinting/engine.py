"""Python wrapper for ImprintingEngine."""
import edgetpu.swig.edgetpu_cpp_wrapper


class ImprintingEngine(edgetpu.swig.edgetpu_cpp_wrapper.ImprintingEngine):
  """Python wrapper for Imprinting Engine."""

  def TrainAll(self, input_data):
    """Trains model given input of all categories.

    Args:
      input_data: {string : list of numpy.array}, map between new
        category's label and training data.

    Returns:
      {int : string}, map between output id and label.
    """
    ret = {}
    for category, tensors in input_data.items():
      ret[self.Train(tensors)] = category
    return ret
