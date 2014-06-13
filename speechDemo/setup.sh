#!/bin/bash
# Put the following in ~/.asoundrc to set the default sound card
# From: https://bbs.archlinux.org/viewtopic.php?pid=975049
# pcm.!default {
#   type plug
#   slave {
#     pcm "hw:1,0"
#   }
# }
# ctl.!default {
#   type hw
#   card 1
# }

apt-get install flite
