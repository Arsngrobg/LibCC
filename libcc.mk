#      ,──.   ,──.,──.    ,─────. ,─────.
#      │  │   `──'│  │─. '  .──./'  .──./
#      │  │   ,──.│ .─. '│  │    │  │
#      │  '──.│  ││ `─' │'  '──'╲'  '──'╲
#      `─────'`──' `───'  `─────' `─────'
#
#      LibCC - lightweight C compiler invocation library

ifndef LIBCC_MK
LIBCC_MK := $(lastword $(MAKEFILE_LIST))

include mymk/mymk.mk

# RELATIVE FILE PATHS
LIBCC_PREFIX := $(dir $(LIBCC_MK))
ifeq ($(LIBCC_PREFIX),./)
LIBCC_PREFIX := $()
endif

# RECIPES
LIBCC_SOURCE := $(LIBCC_PREFIX)libcc.c
LIBCC_OBJECT := $(OBJDIR)/$(LIBCC_PREFIX)libcc.o
LIBCC_SHARED := $(LIBDIR)/$(LIBCC_PREFIX)libcc.$(SOEXT)
LIBCC_STATIC := $(LIBDIR)/$(LIBCC_PREFIX)libcc.a

$(LIBCC_STATIC): $(LIBCC_OBJECT) | $(LIBDIR)/
	@$(LOG) Creating libcc static library (libcc.a)
	@$(AR) $(ARFLAGS) $@ $<

$(LIBCC_SHARED): $(LIBCC_OBJECT) | $(LIBDIR)/
	@$(LOG) Creating libcc shared library (libcc.$(SOEXT))
	@$(CC) $(CFLAGS) $(SOFLAG) -o $@ $<

$(LIBCC_OBJECT): $(LIBCC_SOURCE) | $(OBJDIR)/
	@$(LOG) Compiling $<
	@$(CC) $(CFLAGS) -c $< -o $@

endif # LIBCC_MK
