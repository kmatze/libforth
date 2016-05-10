ECHO	= echo
AR	= ar
CC	= gcc
CFLAGS	= -Wall -Wextra -g -pedantic -fPIC -std=c99 -O2
TARGET	= forth
RM      = rm -rf

.PHONY: all clean 

all: shorthelp $(TARGET) lib$(TARGET).so

shorthelp:
	@$(ECHO) "Use 'make help' for a list of all options"
help:
	@$(ECHO) ""
	@$(ECHO) "project:      lib$(TARGET)"
	@$(ECHO) "description: A small $(TARGET) interpreter and library"
	@$(ECHO) ""
	@$(ECHO) "make (option)*"
	@$(ECHO) ""
	@$(ECHO) "      all             create the $(TARGET) libraries and executables"
	@$(ECHO) "      $(TARGET)           create the $(TARGET) executable"
	@$(ECHO) "      unit            create the unit test executable"
	@$(ECHO) "      test            execute the unit tests"
	@$(ECHO) "      doc             make the project documentation"
	@$(ECHO) "      lib$(TARGET).so     make a shared $(TARGET) library"
	@$(ECHO) "      lib$(TARGET).a      make a static $(TARGET) library"
	@$(ECHO) "      clean           remove generated files"
	@$(ECHO) "      dist            create a distribution archive"
	@$(ECHO) ""

doc: lib$(TARGET).htm 
lib$(TARGET).htm: lib$(TARGET).md
	markdown $^ > $@

lib$(TARGET).a: lib$(TARGET).o
	$(AR) rcs $@ $<

lib$(TARGET).so: lib$(TARGET).o lib$(TARGET).h
	$(CC) $(CFLAGS) -shared $< -o $@

unit: unit.o lib$(TARGET).a

$(TARGET): main.c lib$(TARGET).a
	$(CC) $(CFLAGS) $^ -o $@

forth.core: $(TARGET) start.4th
	./$(TARGET) -d start.4th

dist: $(TARGET) doc
	tar zcf $(TARGET).tgz $(TARGET) *.htm *.so *.a *.h *.4th

run: $(TARGET)
	@./$^ -t start.4th
test: unit
	./$^

clean:
	$(RM) $(TARGET) unit *.blk *.core *.a *.so *.o *.log *.htm *.tgz

