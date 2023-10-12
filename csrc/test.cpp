#include "cubepos.h"
#include <iostream>

int main()
{
    cubepos pos = cubepos(0,0,0);
    const char *human_mv = "R3";
    int mv = pos.parse_move(human_mv);
    pos.move(mv);
    char *str = pos.Singmaster_string();
    std :: cout << str << '\n';
}
