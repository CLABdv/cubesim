#include "c_wrapper_cubepos.h"
#include "cubepos.h"

cubepos_t c_cubepos_init(int a, int b, int c)
{
    return new cubepos(a, b, c);
}

void c_cubepos_delete(cubepos_t cube_untyped)
{
    cubepos *cubeTyped = static_cast<cubepos *>(cube_untyped);
    delete cubeTyped;
}

int c_parse_move(cubepos_t cube_untyped, const char *p)
{
    cubepos *cubeTyped = static_cast<cubepos *>(cube_untyped);
    return cubeTyped->parse_move(p);
}

cubepos_t c_move(cubepos_t cube_untyped, int mv)
{
    cubepos *cubeTyped = static_cast<cubepos *>(cube_untyped);
    cubeTyped->move(mv);
    return cube_untyped; // this is to (hopefully) make haskell not go insane
}

char *c_singmaster_string(cubepos_t cube_untyped)
{
    cubepos *cubeTyped = static_cast<cubepos *>(cube_untyped);
    return cubeTyped->Singmaster_string();
}
