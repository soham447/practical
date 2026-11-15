#include <reg51.h>

void delay()
{
    int i, j;
    for (i = 0; i < 1000; i++)
        for (j = 0; j < 2000; j++);
}

void main()
{
    unsigned char i, j;
    while (1)
    {
        for (i = 0; i < 10; i++)
        {
            for (j = 0; j < 10; j++)
            {
                P2 = (i << 4) | j;
                delay();
            }
        }
    }
}