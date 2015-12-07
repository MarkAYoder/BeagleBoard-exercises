# From:
# Install Arduino IDE.  Version 1.6.6 doesn't seem to work, so using
# next newest version
wget http://arduino.cc/download.php?f=/arduino-1.6.5-r5-linux64.tar.xz
tar --xz xvf arduino-1.6.5-r5-linux64.tar.xz

# Here is fix for epstool
# From: https://github.com/esp8266/Arduino/issues/208
# Scroll 75% the way down to instructions on changing platform.txt

wget https://raw.githubusercontent.com/themadinventor/esptool/master/esptool.py
dir=$PWD
chmod +x esptool.py
cd /usr/local/bin
ln -s $dir/esptool.py .
cd $dir

# edit .arduino15/packages/esp8266/hardware/esp8266/1.6.5-947-g39819f0/platform.txt

tools.esptool.cmd=esptool
tools.esptool.cmd.windows=esptool.exe
tools.esptool.path={runtime.ide.path}/hardware/tools/esp8266

tools.esptool.upload.protocol=esp
tools.esptool.upload.params.verbose=-vv
tools.esptool.upload.params.quiet=
tools.esptool.upload.pattern="{path}/{cmd}" {upload.verbose} -cd {upload.resetmethod} -cb {upload.speed} -cp "{serial.port}" -ca 0x00000 -cf "{build.path}/{build.project_name}_00000.bin" -ca 0x10000 -cf "{build.path}/{build.project_name}_10000.bin"

to

tools.esptool.cmd=esptool.py
tools.esptool.cmd.windows=esptool.exe
tools.esptool.path=/usr/local/bin/

tools.esptool.upload.protocol=esp
tools.esptool.upload.params.verbose=-vv
tools.esptool.upload.params.quiet=
tools.esptool.upload.pattern="{path}/{cmd}" -b {upload.speed} -p "{serial.port}" write_flash 0x00000  "{build.path}/{build.project_name}_00000.bin" 0x10000 "{build.path}/{build.project_name}_10000.bin"


# You may have to:
ln -s blink.cpp.bin blink.cpp_00000.bin
