#ifndef C_WRAPPER_CUBEPOS_H_
#define C_WRAPPER_CUBEPOS_H_
#ifdef __cplusplus
#define EXTERNC extern "C"
#else
#define EXTERNC 
#endif
// see https://stackoverflow.com/questions/2744181/how-to-call-c-function-from-c

typedef void* cubepos_t;
EXTERNC cubepos_t c_cubepos_init(int, int, int);
EXTERNC void c_cubepos_delete(cubepos_t);
EXTERNC int c_parse_move(cubepos_t, const char *);
EXTERNC cubepos_t c_move(cubepos_t, int);
EXTERNC char *c_singmaster_string(cubepos_t);

#endif
