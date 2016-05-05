CC = g++ -ObjC++

CPPFLAG = -O2
LDFLAGS = -framework Foundation -framework CoreFoundation
DEPS = common.h
SOURCES = $(wildcard *.m)
OBJS = $(SOURCES:.m=.o)

TARGETS = InstrumentsParser

all: InstrumentsParser

InstrumentsParser: $(OBJS)
	$(CC) -o $@ $^ $(LDFLAGS)

%.o: %.m
	$(CC) -c -o $@ $< $(CPPFLAG)

clean:
	rm -rf $(TARGETS) $(OBJS)
