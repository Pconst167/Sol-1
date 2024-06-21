CC = gcc
CFLAGS = -std=c11
LIBS = -lm -lncurses

BASENAME = $(notdir $(basename $(FILE)))

.PHONY: compile_file clean

compile_file: cc
ifeq ($(FILE),)
	@echo "Error: Please provide a file to compile using FILE=<filename>"
	@exit 1
else
	./cc $(FILE)
endif

cc: cc.o char.o debug.o search.o
	$(CC) $(CFLAGS) -o cc cc.o char.o debug.o search.o $(LIBS)
	@rm cc.o char.o debug.o search.o

cc.o: cc.c definitions.h
	@$(CC) $(CFLAGS) -c cc.c -o cc.o

char.o: char.c char.h
	@$(CC) $(CFLAGS) -c char.c -o char.o

debug.o: debug.c debug.h
	@$(CC) $(CFLAGS) -c debug.c -o debug.o

search.o: search.c search.h
	@$(CC) $(CFLAGS) -c search.c -o search.o

clean:
	@rm -f cc cc.o char.o debug.o search.o
