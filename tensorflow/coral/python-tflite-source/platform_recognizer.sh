#!/bin/bash
source ./colors.sh
cpu_arch=$(uname -m)
os_version=$(uname -v)

if [[ "$cpu_arch" == "x86_64" ]] && [[ "$os_version" == *"rodete"* ]]; then
  platform="glinux"
  echo -e "${GREEN}Recognized as gLinux!${DEFAULT}"
elif [[ "$cpu_arch" == "x86_64" ]]; then
  platform="x86_64_linux"
  echo -e "${GREEN}Recognized as Linux on x86_64!${DEFAULT}"
elif [[ "$cpu_arch" == "armv7l" ]]; then
  board_version=$(cat /proc/device-tree/model)
  if [[ "$board_version" == "Raspberry Pi 3 Model B Rev"* ]]; then
    platform="raspberry_pi_3b"
    echo -e "${GREEN}Recognized as Raspberry Pi 3 B!${DEFAULT}"
  elif [[ "$board_version" == "Raspberry Pi 3 Model B Plus Rev"* ]]; then
    platform="raspberry_pi_3b+"
    echo -e "${GREEN}Recognized as Raspberry Pi 3 B+!${DEFAULT}"
  fi
elif [[ "$cpu_arch" == "aarch64" ]]; then
  platform="edgetpu_devboard"
  echo -e "${GREEN}Recognized as Edgetpu DevBoard!${DEFAULT}"
else
  platform="unknown"
  echo -e "${RED}Platform not supported!${DEFAULT}"
  exit
fi
