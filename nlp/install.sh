# From http://jupyter.org/install
python3 -m pip install --upgrade pip
sudo python3 -m pip install jupyter

# From http://jupyter-notebook.readthedocs.io/en/stable/public_server.html
jupyter notebook --generate-config
vi ~/.jupyter/jupyter_notebook_config.py
c.NotebookApp.ip = '*'

# From https://github.com/hundredblocks/concrete_NLP_tutorial/blob/master/NLP_notebook.ipynb
sudo pip3 install keras nltk pandas numpy re codecs
