#      ,──.   ,──.,──.    ,─────. ,─────.
#      │  │   `──'│  │─. '  .──./'  .──./
#      │  │   ,──.│ .─. '│  │    │  │
#      │  '──.│  ││ `─' │'  '──'╲'  '──'╲
#      `─────'`──' `───'  `─────' `─────'
#
#      LibCC - lightweight C compiler invocation library

# PROJECT
NAME      := libcc

# COMPILATION & INSTALLATION
CC        ?= cc
CFLAGS    ?= -std=c99 -O2 -Wall -Wextra -Wpedantic
AR        ?= ar
ARFLAGS   := -rcs

# BUILD SYSTEM
LIBCCROOT ?= $(dir $(lastword $(MAKEFILE_LIST)))
LIBCCOBJ  ?= $(notdir $(patsubst %/,%,$(LIBCCROOT)))
BUILDDIR  ?= build
OBJDIR    := $(BUILDDIR)/obj
LIBDIR    := $(BUILDDIR)/lib

# COMPATABILITY
MACHINE   := $(shell $(CC) -dumpmachine)
ifneq ($(findstring mingw,$(MACHINE)),)
MKDIR     := mkdir
RM        := rmdir /S /Q 2>nul
SOEXT     := dll
SOFLAG    := -shared
else
MKDIR     := mkdir -p
RM        := rm -rf
ifneq ($(findstring darwin,$(MACHINE)),)
SOEXT     := dylib
SOFLAG    := -dynamiclib
endif
override CFLAGS += -fPIC
SOEXT     := so
SOFLAG    := -shared
endif

# RECIPES
$(LIBDIR)/$(NAME).$(SOEXT): $(OBJDIR)/$(NAME).o | $(LIBDIR)/
	@echo [Make] creating $(NAME) shared library ($(NAME).$(SOEXT))
	@$(CC) $(SOFLAG) -o $@ $<

$(LIBDIR)/$(NAME).a: $(OBJDIR)/$(NAME).o | $(LIBDIR)/
	@echo [Make] Creating $(NAME) static library ($(NAME).a)
	@$(AR) $(ARFLAGS) $@ $<

$(OBJDIR)/$(NAME).o: $(LIBCCROOT)/$(NAME).c | $(OBJDIR)/
	@echo [Make] Compiling $@
	@$(CC) $(CFLAGS) -c $< -o $@

%/:
	@echo [Make] Creating new directory $(subst /,\,\$(patsubst %/,%,$@))
	@$(MKDIR) $(subst /,\,$@)
