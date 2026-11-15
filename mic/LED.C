#include <lpc214x.h>

void delay(void)
{
    unsigned int i, j;
    for (i = 0; i < 1000; i++)
    {
        for (j = 0; j < 6000; j++);
    }
}

int main(void)
{
    PINSEL2 = 0x00000000;
    IODIR1 |= 0xFF000000;
    while (1)
    {
        IOSET1 = 0xFF000000;
        delay();
        IOCLR1 = 0xFF000000;
        delay();
    }
}