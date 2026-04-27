#                                 ,──.
#    ,──,──,──.,──. ,──.,──,──,──.│  │,─.
#    │        │ ╲  '  ╱ │        ││     ╱
#    │  │  │  │  ╲   '  │  │  │  ││  ╲  ╲
#    `──`──`──'.─'  ╱   `──`──`──'`──'`──'
#              `───'
#    Standardized, cross-platform GNU Make

ifndef MYMK_MK
MYMK_MK := $(lastword $(MAKEFILE_LIST))

# BUILD SYSTEM
BUILDDIR ?= build
OBJDIR   := $(BUILDDIR)/obj
LIBDIR   := $(BUILDDIR)/lib
BINDIR   := $(BUILDDIR)/bin

# SHELL UTILITIES
ifdef ComSpec
PATHSEP := $()\$()
MKDIR   := mkdir
RMDIR   := rmdir /Q /S 2>nul
RM      := del
else
PATHSEP := /
MKDIR   := mkdir -p
RMDIR   := rm -rf
RM      := rm -f
endif # ComSpec
LOG     := echo make:
CC      ?= cc
AR      ?= ar

# FLAGS
CFLAGS  ?= -Wall -Wextra -Werror -Wpedantic
ARFLAGS := -rcs

# LIBRARIES
ifeq ($(OS),Windows_NT)
SOEXT   := dll
SOFLAG  := -shared
else
OS := $(shell uname -s)
ifeq ($(OS),Darwin)
SOEXT   := dylib
SOFLAG  := -dynamiclib
override CFLAGS += -fPIC
else
SOEXT   := so
SOFLAG  := -shared
endif # $(OS),Darwin
endif # $(OS),Windows_NT

# COMMON RECIPES
%/:
	@$(LOG) Creating new directory: $@
	@$(MKDIR) $(subst /,$(PATHSEP),$@)

endif # MYMK_MK
