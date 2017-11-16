#!/usr/bin/python3
# -*- coding: utf-8 -*-

"""
ZetCode Tkinter tutorial

This script shows a simple window
on the screen.

Author: Jan Bodnar
Last modified: July 2017
Website: www.zetcode.com
"""

from tkinter import Tk, BOTH
from tkinter.ttk import Frame

class Example(Frame):
  
    def __init__(self):
        super().__init__()
         
        self.initUI()
        
    
    def initUI(self):
      
        self.master.title("Simple")
        self.pack(fill=BOTH, expand=1)
        

def main():
  
    root = Tk()
    root.geometry("250x150+300+300")
    app = Example()
    root.mainloop()  


if __name__ == '__main__':
    main()   
