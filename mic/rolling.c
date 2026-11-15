#include <reg51.h>

void delay()
{
    int i, j;
    for (i = 0; i < 1000; i++)
        for (j = 0; j < 2000; j++);
}

void main()
{
    unsigned char i;
    while (1)
    {
        for (i = 0x80; i != 0; i = i >> 1)
        {
            P2 = i;
            delay();
        }
    }
}