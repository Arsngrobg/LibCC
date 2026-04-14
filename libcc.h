#ifndef LIBCC_H
#define LIBCC_H

#define MAX_ARG ((32 << 10) / sizeof(char))

typedef enum {
    CC_OK,
    CC_FAIL
} CC_Status;

typedef enum {
    CC_GCC,
    CC_CLANG, // TODO: not supported as of now
    CC_MSVC   // TODO: not supported as of now
} CC_Compiler;

// cc [<flags>] [<includes>] [<lpaths>] [<libs>] -c [<sources>] -o [<output>]
typedef struct {
    char  *render[MAX_ARG]; // render cache per state
    CC_Compiler cc;
    char **flags;
    char **includes;
    char **libpaths;
    char **libraries;
    char **sources;
    char  *output;
} CC_State;

// construction
CC_State *CC_New   ();
void      CC_Delete(CC_State *cc);

// functions
CC_Status  CC_Set       (CC_State *cc, CC_Compiler c);
CC_Status  CC_AddFlag   (CC_State *cc, char *flag);
CC_Status  CC_AddInclude(CC_State *cc, char *include);
CC_Status  CC_AddLibPath(CC_State *cc, char *libpath);
CC_Status  CC_AddLib    (CC_State *cc, char *lib);
CC_Status  CC_AddSource (CC_State *cc, char *source);
char      *CC_RenderCMD (CC_State *cc);

#endif // LIBCC_H
