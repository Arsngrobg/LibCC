#      ,──.   ,──.,──.    ,─────. ,─────.
#      │  │   `──'│  │─. '  .──./'  .──./
#      │  │   ,──.│ .─. '│  │    │  │
#      │  '──.│  ││ `─' │'  '──'╲'  '──'╲
#      `─────'`──' `───'  `─────' `─────'
#
#      LibCC - lightweight C compiler invocation library

include libcc.mk

all: shared static

shared: $(LIBCC_SHARED)

static: $(LIBCC_STATIC)

clean:
	@$(LOG) Purging $(BUILDDIR) directory
	@$(RMDIR) $(subst /,$(PATHSEP),$(BUILDDIR))

.DEFAULT_GOAL = all
.PHONY: all shared static clean
