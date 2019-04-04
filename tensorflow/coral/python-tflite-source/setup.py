#!/usr/bin/env python
import edgetpu
from setuptools import find_packages, setup


setup(
  name='edgetpu',
  version=edgetpu.__version__,
  description='EdgeTPU Python API',
  author='AIY Projects',
  author_email='support-aiyprojects@google.com',
  url='https://aiyprojects.googlesource.com/python-tflite-source',
  license='Apache 2',
  packages=find_packages('.'),
  package_data={
    '': [
      'swig/_edgetpu_cpp_wrapper.so',
    ]
  },
  include_package_data=True,
  python_requires='>=3.5.0',
  install_requires=[
    'numpy',
    'pillow',
  ],
)
