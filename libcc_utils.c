//     ,──.   ,──.,──.    ,─────. ,─────.
//     │  │   `──'│  │─. '  .──./'  .──./
//     │  │   ,──.│ .─. '│  │    │  │
//     │  '──.│  ││ `─' │'  '──'╲'  '──'╲
//     `─────'`──' `───'  `─────' `─────'
//
//     LibCC - lightweight C compiler invocation library

#include <stdlib.h>
#include <string.h>

typedef struct {
    size_t  length;
    char   *args[];
} CC_ArgList;

char *cc_strdup        (const char *s);
bool  cc_arglist_append(CC_ArgList *list, const char *arg);

char *cc_strdup(const char *s) {
    if (s == NULL) {
        return NULL;
    }

    size_t len = strlen(s) + 1;
    char  *cpy = malloc(sizeof(char) * len);
    if (cpy == NULL) {
        return NULL;
    }

    memcpy(cpy, s, sizeof(char) * len);
    return cpy;
}

// this is a very dumb and simple reallocation method
// TODO: optimization
bool cc_arglist_append(CC_ArgList *list, const char *arg) {
    assert(list != NULL);

    size_t old_len = list->length;
    list = realloc(list, sizeof(CC_ArgList) + (sizeof(char*) * (list->length + 1)));
    if (list == NULL) {
        fprintf(stderr, "Unable to resize CC_ArgList\n");
        return false;
    }

    list->length = old_len + 1;
    list->args[list->length] = cc_strdup(arg);
    return true;
}
