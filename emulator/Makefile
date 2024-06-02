CC = gcc
CFLAGS = -std=c99
LIBS = -lm

.PHONY: compile_file

compile_file: emulator
	./emulator $(FILE)

emulator: emulator.c
	$(CC) $(CFLAGS) -o emulator emulator.c $(LIBS)


clean:
	rm -f emulator emulator.o
