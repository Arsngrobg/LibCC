//     ,──.   ,──.,──.    ,─────. ,─────.
//     │  │   `──'│  │─. '  .──./'  .──./
//     │  │   ,──.│ .─. '│  │    │  │
//     │  '──.│  ││ `─' │'  '──'╲'  '──'╲
//     `─────'`──' `───'  `─────' `─────'
//
//     LibCC - lightweight C compiler invocation library

#ifndef LIBCC_H
#define LIBCC_H

#define CC_COMPILER_DEFAULT "cc"
#define CC_COMPILER_GCC     "gcc"
#define CC_COMPILER_CLANG   "clang" // TODO: not natively supported
#define CC_COMPILER_MSVC    "cl"    // TODO: not natively supported
#define CC_PROFILE_GCC      (CC_COMPILER_GCC),   (CC_STYLE_GNU)
#define CC_PROFILE_CLANG    (CC_COMPILER_CLANG), (CC_STYLE_GNU)
#define CC_PROFILE_MSVC     (CC_COMPILER_MSVC),  (CC_STYLE_MSVC)

#include <stdbool.h>

typedef enum {
    CC_STYLE_GNU, // GCC or Clang
    CC_STYLE_MSVC // MSVC
} CC_Invocation_Style;

typedef struct CC_Toolchain CC_Toolchain;

// Construction
CC_Toolchain *cc_new   (void);
void          cc_delete(CC_Toolchain *cc);

// Operations
void        cc_set_invocation_style(CC_Toolchain *cc, CC_Invocation_Style style);
bool        cc_set_profile         (CC_Toolchain *cc, const char *ccid, CC_Invocation_Style style);
bool        cc_set_compiler        (CC_Toolchain *cc, const char *ccid); // [<CCID>]
bool        cc_add_flag            (CC_Toolchain *cc, const char *flag); // cc    [<FLAG>]
bool        cc_add_include_path    (CC_Toolchain *cc, const char *path); // cc -I[<PATH>]
bool        cc_add_library_path    (CC_Toolchain *cc, const char *path); // cc -L[<PATH>]
bool        cc_add_library         (CC_Toolchain *cc, const char *lib);  // cc -l[<LIB>]
bool        cc_add_source          (CC_Toolchain *cc, const char *file); // cc    [<FILE>]
bool        cc_set_output          (CC_Toolchain *cc, const char *out);  // cc -o [<OUT>]
const char *cc_render_command      (CC_Toolchain *cc);                   // [<CCID>] [<FLAG>]* (-I[<PATH>])* (-L[<PATH>])* (-l[<LIB>])* [<FILE>]+ -o [<OUT>]
int         cc_invoke              (CC_Toolchain *cc);

#endif // LIBCC_H
