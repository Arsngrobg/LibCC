#      ,──.   ,──.,──.    ,─────. ,─────.
#      │  │   `──'│  │─. '  .──./'  .──./
#      │  │   ,──.│ .─. '│  │    │  │
#      │  '──.│  ││ `─' │'  '──'╲'  '──'╲
#      `─────'`──' `───'  `─────' `─────'
#
#      LibCC - lightweight C compiler invocation library

include libcc.mk

all: shared static

shared: $(LIBDIR)/$(NAME).$(SOEXT)

static: $(LIBDIR)/$(NAME).a

clean:
	@echo make: Purging $(BUILDDIR) directory
	@$(RM) $(subst /,\,$(BUILDDIR)) || exit 0

.DEFAULT_GOAL = all
.PHONY: all shared static clean
