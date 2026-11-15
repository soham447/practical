#include "lpc214x.h"
#include <stdio.h>

#define PCLK 15000000UL

void UartInit(unsigned int baudrate);
int  UART_GetChar(void);
int  UART_PutChar(unsigned char Ch);

void UartInit(unsigned int baudrate)
{
    unsigned int FDiv;
    PINSEL0 = (PINSEL0 & 0xFFFFFFF0) | 0x00000005;  // P0.0 TXD0, P0.1 RXD0
    U0LCR = 0x83;                                    // 8N1, DLAB = 1
    FDiv = PCLK / (16UL * baudrate);
    U0DLM = FDiv / 256;
    U0DLL = FDiv % 256;
    U0LCR = 0x03;                                    // DLAB = 0
    U0TER = 0x80;
}

int UART_GetChar(void)
{
    while (!(U0LSR & 0x01));
    return U0RBR;
}

int UART_PutChar(unsigned char Ch)
{
    while (!(U0LSR & 0x20));
    U0THR = Ch;
    return Ch;
}

struct __FILE { int handle; };
FILE __stdout;

int fputc(int ch, FILE *f)
{
    return UART_PutChar(ch);
}

int main(void)
{
    UartInit(9600);
    printf("\r\nThis is a Demonstration for \r\nUART peripheral for LPC2148\r\nDone on SBC_ARM7 Board \r\n");
    printf("\r\nHit any Key on your PC Keyboard to see result\r\n");

    while (1)
    {
        UART_PutChar(UART_GetChar());   // echo
    }
}