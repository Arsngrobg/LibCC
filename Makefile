#      ,──.   ,──.,──.    ,─────. ,─────.
#      │  │   `──'│  │─. '  .──./'  .──./
#      │  │   ,──.│ .─. '│  │    │  │
#      │  '──.│  ││ `─' │'  '──'╲'  '──'╲
#      `─────'`──' `───'  `─────' `─────'
#
#      LibCC - lightweight C compiler invocation library

include mymk/mymk.mk
include libcc.mk

all: shared static

shared: $(LIBCC_SHARED)

static: $(LIBCC_STATIC)

clean:
	@$(LOG) Purging $(BUILDDIR) directory
	@$(RMDIR) $(subst /,\,$(BUILDDIR))

.DEFAULT_GOAL = all
.PHONY: all shared static clean
