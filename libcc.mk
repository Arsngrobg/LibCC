#      ,──.   ,──.,──.    ,─────. ,─────.
#      │  │   `──'│  │─. '  .──./'  .──./
#      │  │   ,──.│ .─. '│  │    │  │
#      │  '──.│  ││ `─' │'  '──'╲'  '──'╲
#      `─────'`──' `───'  `─────' `─────'
#
#      LibCC - lightweight C compiler invocation library

ifndef LIBCC_MK
LIBCC_MK := $(dir $(lastword $(MAKEFILE_LIST)))

include $(LIBCC_MK)mymk.mk

# RELATIVE FILE PATHS
LIBCC_PREFIX := $(patsubst %/,%,$(LIBCC_MK))
LIBCC_OBJDIR := $(notdir $(patsubst %/,%,$(LIBCC_PREFIX)))

# RECIPES
LIBCC_SOURCE := $(LIBCC_PREFIX)/libcc.c
LIBCC_OBJECT := $(OBJDUMP)/$(LIBCC_OBJDIR)/libcc.o
LIBCC_SHARED := $(LIBDUMP)/libcc.$(SOEXT)
LIBCC_STATIC := $(LIBDUMP)/libcc.a

$(LIBCC_STATIC): $(LIBCC_OBJECT) | $(LIBDUMP)/
	@$(LOG) Creating libcc static library (libcc.a)
	@$(AR) $(ARFLAGS) $@ $<

$(LIBCC_SHARED): $(LIBCC_OBJECT) | $(LIBDUMP)/
	@$(LOG) Creating libcc shared library (libcc.$(SOEXT))
	@$(CC) $(CFLAGS) $(SOFLAG) -o $@ $<

$(LIBCC_OBJECT): $(LIBCC_SOURCE) | $(OBJDUMP)/$(LIBCC_PREFIX)/
	@$(LOG) Compiling $<
	@$(CC) $(CFLAGS) -c $< -o $@

endif # LIBCC_MK
