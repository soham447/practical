#include <reg51.h>

void delay()
{
    int i, j;
    for (i = 0; i < 1000; i++)
        for (j = 0; j < 10000; j++);
}

void main()
{
    unsigned char a[] = {
        0xBF, 0x86, 0xDB, 0xCF, 0xE6,
        0xED, 0xFD, 0x87, 0xFF, 0xEF
    };
    unsigned char i;
    while (1)
    {
        for (i = 0; i < 10; i++)
        {
            P2 = a[i];
            delay();
        }
    }
}