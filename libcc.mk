#      ,──.   ,──.,──.    ,─────. ,─────.
#      │  │   `──'│  │─. '  .──./'  .──./
#      │  │   ,──.│ .─. '│  │    │  │
#      │  '──.│  ││ `─' │'  '──'╲'  '──'╲
#      `─────'`──' `───'  `─────' `─────'
#
#      LibCC - lightweight C compiler invocation library

ifndef LIBCC_MK
LIBCC_MK := $(lastword $(MAKEFILE_LIST))

-include mymk/mymk.mk

# RELATIVE FILE PATHS
LIBCC_PREFIX := $(notdir $(patsubst %/,%,$(dir $(LIBCC_MK))))

# RECIPES
LIBCC_SOURCE := $(LIBCC_PREFIX)/libcc.c
LIBCC_OBJECT := $(OBJDIR)/$(LIBCC_PREFIX)/libcc.o
LIBCC_SHARED := $(LIBDIR)/libcc.$(SOEXT)
LIBCC_STATIC := $(LIBDIR)/libcc.a

$(LIBCC_STATIC): $(LIBCC_OBJECT) | $(LIBDIR)/
	@$(LOG) Creating libcc static library (libcc.a)
	@$(AR) $(ARFLAGS) $@ $<

$(LIBCC_SHARED): $(LIBCC_OBJECT) | $(LIBDIR)/
	@$(LOG) Creating libcc shared library (libcc.$(SOEXT))
	@$(CC) $(CFLAGS) $(SOFLAG) -o $@ $<

$(LIBCC_OBJECT): $(LIBCC_SOURCE) | $(OBJDIR)/$(LIBCC_PREFIX)/
	@$(LOG) Compiling $<
	@$(CC) $(CFLAGS) -c $< -o $@

endif # LIBCC_MK
