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

# BUILD VARIABLES
LIBCC_SOURCE := $(LIBCCROOT)/$(NAME).c
LIBCC_OBJECT := $(OBJDIR)/$(LIBCCOBJ)/$(NAME).o
LIBCC_STATIC := $(LIBDIR)/$(NAME).a
LIBCC_SHARED := $(LIBDIR)/$(NAME).$(SOEXT)

# RECIPES
$(LIBCC_SHARED): $(LIBCC_OBJECT) | $(LIBDIR)/
	@echo make: creating $(NAME) shared library ($(NAME).$(SOEXT))
	@$(CC) $(SOFLAG) -o $@ $<

$(LIBCC_STATIC): $(LIBCC_OBJECT) | $(LIBDIR)/
	@echo make: Creating $(NAME) static library ($(NAME).a)
	@$(AR) $(ARFLAGS) $@ $<

$(LIBCC_OBJECT): $(LIBCC_SOURCE) | $(OBJDIR)/
	@echo make: Compiling $@
	@$(CC) $(CFLAGS) -c $< -o $@

%/:
	@echo make: Creating new directory $(subst /,\,\$(patsubst %/,%,$@))
	@$(MKDIR) $(subst /,\,$@)
