#      ,──.   ,──.,──.    ,─────. ,─────.
#      │  │   `──'│  │─. '  .──./'  .──./
#      │  │   ,──.│ .─. '│  │    │  │
#      │  '──.│  ││ `─' │'  '──'╲'  '──'╲
#      `─────'`──' `───'  `─────' `─────'
#
#      LibCC - lightweight C compiler invocation library

# PROJECT
NAME     := libcc

# COMPILATION & INSTALLATION
CC       ?= cc
CFLAGS   ?= -std=c99 -O2 -Wall -Wextra -Wpedantic
AR       ?= ar
ARFLAGS  := -rcs
PREFIX   ?= /usr/local

# BUILD SYSTEM
BUILDDIR ?= build
OBJDIR   := $(BUILDDIR)/obj
LIBDIR   := $(BUILDDIR)/lib

# COMPATABILITY
MACHINE  := $(shell $(CC) -dumpmachine)
ifneq ($(findstring mingw,$(MACHINE)),)
MKDIR    := mkdir
RM       := rmdir /S /Q 2>nul
SOEXT    := dll
SOFLAG   := -shared
else
MKDIR    := mkdir -p
RM       := rm -rf
ifneq ($(findstring darwin,$(MACHINE)),)
SOEXT    := dylib
SOFLAG   := -dynamiclib
endif
override CFLAGS += -fPIC
SOEXT    := so
SOFLAG   := -fPIC -shared
endif

# RECIPES
$(LIBDIR)/$(NAME).$(SOEXT): $(OBJDIR)/$(NAME).o | $(LIBDIR)/
	@echo [Make] creating $(NAME) shared library ($(NAME).$(SOEXT))
	@$(CC) $(SOFLAG) -o $@ $<

$(LIBDIR)/$(NAME).a: $(OBJDIR)/$(NAME).o | $(LIBDIR)/
	@echo [Make] Creating $(NAME) static library ($(NAME).a)
	@$(AR) $(ARFLAGS) $@ $<

$(OBJDIR)/$(NAME).o: $(NAME).c | $(OBJDIR)/
	@echo [Make] Compiling $@
	@$(CC) $(CFLAGS) -c $< -o $@

%/:
	@echo [Make] Creating new directory $(subst /,\,\$(patsubst %/,%,$@))
	@$(MKDIR) $(subst /,\,$@)

#     ,────────.              ,──.
#     '──.  .──',──,──. ,───. │  │,─.  ,───.
#        │  │  ' ,─.  │(  .─' │     ╱ (  .─'
#        │  │  ╲ '─'  │.─'  `)│  ╲  ╲ .─'  `)
#        `──'   `──`──'`────' `──'`──'`────'
#     Phony targets

all: shared static

shared: $(LIBDIR)/$(NAME).$(SOEXT)

static: $(LIBDIR)/$(NAME).a

install:

clean:
	@echo [Make] Purging $(BUILDDIR) directory
	@$(RM) $(subst /,\,$(BUILDDIR))

.DEFAULT_GOAL = all
.PHONY: all install install-shared install-static clean
