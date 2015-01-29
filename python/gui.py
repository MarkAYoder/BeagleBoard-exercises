#!/usr/bin/env python
# From: http://people.ds.cam.ac.uk/mcj33/themagpi/The-MagPi-issue-29-en.pdf
from Tkinter import *
window = Tk()
window.title('GUI Tkinter 1')
window.geometry("300x250") # w x h
window.resizable(0,0)

#define labels
box1 = Label(window,text="Entry 1: ")

#place the label in the window object
box1.grid(row = 1, column = 1, padx = 5, pady = 5)

#define functions for button(s)
def btn1():
    print ("button pressed")

#create button objects
btn_tog2 = Button(window, text ='button1', command=btn1)
btn_exit = Button(window, text ='exit',command=exit)

#place button objects
btn_tog2.grid(row = 1, column = 2, padx = 5, pady = 5)
btn_exit.grid(row = 2, column = 2, padx = 5, pady = 5)

#define labels
button1 = Label(window, text="click button")
button2 = Label(window, text="exit program")

#place labels
button1.grid(row = 1, column = 1, padx = 5, pady = 5)
button2.grid(row = 2, column = 1, padx = 5, pady = 5)

window.mainloop()