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
        for (i = 0x00; i < 0xFF; i++)
        {
            P2 = i;
            delay();
        }
    }
}