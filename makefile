#
# picberry Makefile
# 
#
CC = g++
CFLAGS = -Wall -O2 -s -std=c++11
TARGET = picberry
PREFIX = /usr
BINDIR = $(PREFIX)/bin
SRCDIR = src
BUILDDIR = build

GCCVERSION := $(shell expr `gcc -dumpversion | cut -f2 -d.` \>= 7)

ifeq "$(GCCVERSION)" "0"
    CC = g++-4.7
endif

DEVICES = $(BUILDDIR)/devices/dspic33e.o \
		  $(BUILDDIR)/devices/dspic33f.o \
		  $(BUILDDIR)/devices/pic18fj.o \
		  $(BUILDDIR)/devices/pic24fj.o

a10: CFLAGS += -DBOARD_A10
raspberrypi: CFLAGS += -DBOARD_RPI
am335x: CFLAGS += -DBOARD_AM335X

default:
	 @echo "Please specify a target with 'make raspberrypi', 'make a10' or 'make am335x'."

raspberrypi: picberry gpio_test
a10: picberry gpio_test
am335x: picberry gpio_test

picberry:  $(BUILDDIR)/inhx.o $(DEVICES) $(BUILDDIR)/picberry.o  
	$(CC) $(CFLAGS) -o $(TARGET) $(BUILDDIR)/inhx.o $(DEVICES) $(BUILDDIR)/picberry.o

gpio_test:  $(BUILDDIR)/gpio_test.o
	$(CC) $(CFLAGS) -o gpio_test $(BUILDDIR)/gpio_test.o

$(BUILDDIR)/%.o: $(SRCDIR)/%.cpp
	$(CC) $(CFLAGS) -c $< -o $@
	
$(BUILDDIR)/devices/%.o: $(SRCDIR)/devices/%.cpp
	$(CC) $(CFLAGS) -c $< -o $@

install:
	install -m 0755 $(TARGET) $(BINDIR)/$(TARGET)

uninstall:
	$(RM) $(BINDIR)/$(TARGET)

clean: 
	$(RM) $(TARGET) *_test *.o $(BUILDDIR)/*.o $(BUILDDIR)/devices/*.o
