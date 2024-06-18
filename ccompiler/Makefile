CC = gcc
CFLAGS = -std=c99
LIBS = -lm -lncurses

BASENAME = $(notdir $(basename $(FILE)))


.PHONY: compile_file

compile_file: cc
ifeq ($(FILE),)
	@echo "Error: Please provide a file to compile using FILE=<filename>"
	@exit 1
else
	./cc $(FILE)
endif

cc: cc.o char.o debug.o
	@$(CC) $(CFLAGS) -o cc cc.o char.o debug.o $(LIBS)
	@rm cc.o char.o debug.o

cc.o: cc.c definitions.h
	@$(CC) $(CFLAGS) -c cc.c -o cc.o

char.o: char.c char.h
	@$(CC) $(CFLAGS) -c char.c -o char.o

debug.o: debug.c debug.h
	@$(CC) $(CFLAGS) -c debug.c -o debug.o

clean:
	@rm -f cc cc.o char.o debug.o
