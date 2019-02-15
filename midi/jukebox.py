#!/usr/bin/env python3
# From: https://github.com/mido/mido

import mido
import time
import subprocess, signal, os

# See what ports are out there
# print(mido.get_output_names())
# print(mido.get_input_names())

organ = "MidiSport 1x1:MidiSport 1x1 MIDI 1 20:0"
outport = mido.open_output(organ)

mypath = 'midifiles'

from os import listdir
from os.path import isfile, join

files = [f for f in listdir(mypath) if isfile(join(mypath, f))]
offset = 3  # Number of tabs in to start

files.sort()
print(files)
print(len(files))

def lightsOn(count):
    print("Sending cancel")
    msg = mido.Message('sysex', data=[0, 74, 79, 72, 65, 83, 127])
    outport.send(msg)
    
    for i in range(offset, count+offset):
        msg = mido.Message('program_change', channel=11, program=i)
        # print(msg)
        outport.send(msg)

def lightsOff():
    print("Sending cancel")
    msg = mido.Message('sysex', data=[0, 74, 79, 72, 65, 83, 127])
    outport.send(msg)
    
def lightsOnOne(light):
    lightsOff()
    msg = mido.Message('program_change', channel=11, program=light)
    outport.send(msg)

pro=0
with mido.open_input(organ) as inport:
    print(inport)
    for msg in inport:
        print(msg)
        if msg.type == 'note_on' and msg.note == 36 and msg.velocity != 0:
            print("What shall I play?")
            # See if something is already playing and kill it
            if pro != 0:
                print("Terminating")
                os.killpg(os.getpgid(pro.pid), signal.SIGTERM)
                # pro.terminate()
                outport.reset()
                pro=0

            lightsOn(len(files))
            # Wait for messages to pass
            time.sleep(0.2)     # Wait for messages to arrive
            for msg in inport.iter_pending():
                print(msg)
            selection = inport.receive()
            print(selection)
            if selection.type == 'program_change':
                print(selection.program)
                print("Playing: " + files[selection.program-offset])

                pro = subprocess.Popen(["./playMidi.sh", 
                        mypath + "/" + files[selection.program-offset],
                        str(selection.program)], 
                        preexec_fn=os.setsid)
                print(pro)
                print(pro.pid)
