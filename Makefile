CFLAGS = -Wall -Wextra

SOURCES = $(wildcard *.c)
OBJS = $(patsubst %.c, %.o, $(SOURCES))

.PHONY:	all clean

all:	mad

clean:
	$(RM) mad *.o

mad:	$(OBJS)
	$(CC) -o $@ $^
