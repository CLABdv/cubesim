#ifndef CWRAPPER_CUBEPOS_H_
#define CWRAPPER_CUBEPOS_H_
#ifdef __cplusplus
#define EXTERNC extern "C"
#else
#define EXTERNC 
#endif
// see https://stackoverflow.com/questions/2744181/how-to-call-c-function-from-c

typedef void* cubepos_t;
EXTERNC cubepos_t c_cubepos(int, int, int);
EXTERNC int c_parse_move(cubepos_t, const char *);
EXTERNC int c_move(cubepos_t, int);
EXTERNC char *c_singmaster_string(cubepos_t);

#endif
