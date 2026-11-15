#include <reg51.h>

unsigned char STEP_LUT[] = {1, 2, 4, 8};

void DelayMs(unsigned int delay)
{
    unsigned int i, j;
    for (i = 0; i < delay; i++)
        for (j = 0; j < 5000; j++);
}

void main(void)
{
    unsigned int i;
    while (1)
    {
        for (i = 0; i <= 3; i++)
        {
            P2 = STEP_LUT[i];
            DelayMs(5000);
            P2 = 0x0F;
            DelayMs(5000);
        }
    }
}