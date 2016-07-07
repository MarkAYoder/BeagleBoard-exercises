
# CC=arm-none-linux-gnueabi-gcc

objs = prudbg.o cmdinput.o cmd.o printhelp.o da.o uio.o

prudebug : ${objs}
	${CC} ${objs} -o prudebug

clean:
	rm ${objs} prudebug

