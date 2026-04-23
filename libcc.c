//     ,──.   ,──.,──.    ,─────. ,─────.
//     │  │   `──'│  │─. '  .──./'  .──./
//     │  │   ,──.│ .─. '│  │    │  │
//     │  '──.│  ││ `─' │'  '──'╲'  '──'╲
//     `─────'`──' `───'  `─────' `─────'
//
//     LibCC - lightweight C compiler invocation library

#include "libcc.h"

#include <assert.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>

#include "libcc_utils.c"

#define LIBCC_ARGMAX ((32 << 10) - 1) // 32KB - Windows compatible

struct CC_Toolchain {
    // Local render cache for the command
    char render[LIBCC_ARGMAX];

    // Invocation
    char *ccid;
    CC_InvocationStyle invoke_style;

    // Arguments
    CC_ArgList *options;
    CC_ArgList *include_paths;
    CC_ArgList *lib_paths;
    CC_ArgList *libs;
    CC_ArgList *sources;
};

CC_Toolchain *cc_new(void) {
    CC_Toolchain *cc = malloc(sizeof(CC_Toolchain));
    if (cc == NULL) {
        fprintf(stderr, "Unable to allocate enough memory for a new CC_Toolchain\n");
        return NULL;
    }

    cc->ccid = cc_strdup(CC_COMPILER_DEFAULT);
    return cc;
}

void cc_delete(CC_Toolchain *cc) {
    free(cc);
}

bool cc_set_profile(CC_Toolchain *cc, const char *ccid, CC_InvocationStyle style) {
    return cc_set_compiler(cc, ccid) && cc_set_invocation_style(cc, style);
}

bool cc_set_invocation_style(CC_Toolchain *cc, CC_InvocationStyle style) {
    if (cc == NULL) {
        fprintf(stderr, "CC_Toolchain cannot be NULL\n");
        return false;
    }

    cc->invoke_style = style;
    return true;
}

bool cc_set_compiler(CC_Toolchain *cc, const char *ccid) {
    if (cc == NULL) {
        fprintf(stderr, "CC_Toolchain cannot be NULL\n");
        return false;
    }

    free(cc->ccid);
    cc->ccid = cc_strdup(ccid);
    return true;
}

bool cc_add_option(CC_Toolchain *cc, const char *option) {
    if (cc == NULL) {
        fprintf(stderr, "CC_Toolchain cannot be NULL\n");
        return false;
    }

    cc_arglist_append(cc->options, option);
    return true;
}

bool cc_add_include_path(CC_Toolchain *cc, const char *path) {
    if (cc == NULL) {
        fprintf(stderr, "CC_Toolchain cannot be NULL\n");
        return false;
    }

    cc_arglist_append(cc->include_paths, path);
    return true;
}

bool cc_add_library_path(CC_Toolchain *cc, const char *path) {
    if (cc == NULL) {
        fprintf(stderr, "CC_Toolchain cannot be NULL\n");
        return false;
    }

    cc_arglist_append(cc->lib_paths, path);
    return true;
}

bool cc_add_library(CC_Toolchain *cc, const char *lib) {
    if (cc == NULL) {
        fprintf(stderr, "CC_Toolchain cannot be NULL\n");
        return false;
    }

    cc_arglist_append(cc->libs, lib);
    return true;
}

bool cc_add_source(CC_Toolchain *cc, const char *source) {
    if (cc == NULL) {
        fprintf(stderr, "CC_Toolchain cannot be NULL\n");
        return false;
    }

    cc_arglist_append(cc->sources, source);
    return true;
}

bool cc_set_outut(CC_Toolchain *cc, const char *out) {
    char fmtbuf[LIBCC_ARGMAX];
    if (snprintf(fmtbuf, LIBCC_ARGMAX, "-o %s", out) < LIBCC_ARGMAX) {
        fprintf(stderr, "Unable to set the output file '%s'\n", out);
        return false;
    }

    return cc_add_option(cc, fmtbuf);
}

const char *cc_render_command(CC_Toolchain *cc) {
    if (cc == NULL) {
        fprintf(stderr, "CC_Toolchain cannot be NULL\n");
        return false;
    }

    size_t len = 0;

    // TODO: this can error if, for some reason, you have a command that is larger than 32KB
    // options
    for (size_t opt = 0; opt < cc->options->length; opt++) {
        size_t len = strlen(cc->options->args[opt]);
        for (size_t idx = 0; idx < len; idx++) {
            cc->render[len++] = cc->options->args[opt][idx];
        }
    }

    // include paths
    for (size_t inc = 0; inc < cc->include_paths->length; inc++) {
        cc->render[len++] = '-';
        cc->render[len++] = 'I';

        size_t len = strlen(cc->include_paths->args[inc]);
        for (size_t idx = 0; idx < len; idx++) {
            cc->render[len++] = cc->include_paths->args[inc][idx];
        }
    }

    // lib paths
    for (size_t libp = 0; libp < cc->lib_paths->length; libp++) {
        cc->render[len++] = '-';
        cc->render[len++] = 'L';

        size_t len = strlen(cc->lib_paths->args[libp]);
        for (size_t idx = 0; idx < len; idx++) {
            cc->render[len++] = cc->lib_paths->args[libp][idx];
        }
    }

    // libs
    for (size_t lib = 0; lib < cc->libs->length; lib++) {
        cc->render[len++] = '-';
        cc->render[len++] = 'L';

        size_t len = strlen(cc->libs->args[lib]);
        for (size_t idx = 0; idx < len; idx++) {
            cc->render[len++] = cc->libs->args[lib][idx];
        }
    }

    // sources
    for (size_t src = 0; src < cc->sources->length; src++) {
        size_t len = strlen(cc->sources->args[src]);
        for (size_t idx = 0; idx < len; idx++) {
            cc->render[len++] = cc->sources->args[src][idx];
        }
    }

    cc->render[len++] = '\0';
    return cc->render;
}
