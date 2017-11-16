#!/usr/bin/python3
# -*- coding: utf-8 -*-

"""
ZetCode Tkinter tutorial

This program creates a Quit
button. When we press the button,
the application terminates. 

Author: Jan Bodnar
Last modified: July 2017
Website: www.zetcode.com
"""

from tkinter import Tk, BOTH
from tkinter.ttk import Frame, Button, Style

class Example(Frame):
  
    def __init__(self):
        super().__init__()   
         
        self.initUI()
        
        
    def initUI(self):
        
        self.style = Style()
        self.style.theme_use("default")
      
        self.master.title("Quit button")
        self.pack(fill=BOTH, expand=1)

        quitButton = Button(self, text="Quit",
            command=self.quit)
        quitButton.place(x=50, y=50)


def main():
  
    root = Tk()
    root.geometry("250x150+300+300")
    app = Example()
    root.mainloop()  


if __name__ == '__main__':
    main()   
