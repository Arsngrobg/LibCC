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

# SHELL UTILITIES
ifdef ComSpec # cmd.exe/Powershell.exe most likely
FSEP      := \\
CP        := copy /y >nul
MKDIR     := mkdir
RM        := rmdir /S /Q 2>nul
else
FSEP      := /
CP        := cp
MKDIR     := mkdir -p
RM        := rm -rf
endif
LOG       := echo make:

# LIBRARY FORMATTING
MACHINE   := $(shell $(CC) -dumpmachine)
ifneq ($(findstring mingw,$(MACHINE)),)
SOEXT     := dll
SOFLAG    := -shared
else ifneq ($(findstring darwin,$(MACHINE)),)
SOEXT     := dylib
SOFLAG    := -dynamiclib
else
SOEXT     := so
SOFLAG    := -shared
override CFLAGS += -fPIC
endif

# RECIPES
LIBCC_SOURCE := $(LIBCCROOT)/$(NAME).c
LIBCC_OBJECT := $(OBJDIR)/$(LIBCCOBJ)/$(NAME).o
LIBCC_STATIC := $(LIBDIR)/$(NAME).a
LIBCC_SHARED := $(LIBDIR)/$(NAME).$(SOEXT)

$(LIBCC_SHARED): $(LIBCC_OBJECT) | $(LIBDIR)/
	@$(LOG) Creating $(NAME) shared library ($(NAME).$(SOEXT))
	@$(CC) $(SOFLAG) -o $@ $<

$(LIBCC_STATIC): $(LIBCC_OBJECT) | $(LIBDIR)/
	@$(LOG) Creating $(NAME) static library ($(NAME).a)
	@$(AR) $(ARFLAGS) $@ $<

$(LIBCC_OBJECT): $(LIBCC_SOURCE) | $(OBJDIR)/$(LIBCCOBJ)/
	@$(LOG) Compiling $@
	@$(CC) $(CFLAGS) -c $< -o $@

%/:
	@$(LOG) Creating new directory $@
	@$(MKDIR) $(subst /,$(FSEP),$@)
