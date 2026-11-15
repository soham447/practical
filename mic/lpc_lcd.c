#include <lpc214x.h>

#define LCD_PORT 0x00FF0000
#define LCD_SHIFT 16

#define EN (1U<<10)
#define RS (1U<<11)
#define RW (1U<<20)

void delay(unsigned int time);
void LCD_strobe(void);
void LCD_data(unsigned char ch);
void LCD_cmd(unsigned char ch);
void LCD_init(void);
void LCD_display(unsigned int row, unsigned int pos, const char *str);

void delay(unsigned int time)
{
    volatile unsigned int i, j;
    for (i = 0; i < time; i++)
    {
        for (j = 0; j < 100; j++)
        {
        }
    }
}

void LCD_strobe(void)
{
    IOSET0 = EN;
    delay(10);
    IOCLR0 = EN;
    delay(10);
}

void LCD_data(unsigned char ch)
{
    IOCLR1 = LCD_PORT;
    IOSET1 = ((unsigned int)ch << LCD_SHIFT);
    IOSET0 = RS;
    IOCLR0 = RW;
    LCD_strobe();
    delay(2);
}

void LCD_cmd(unsigned char ch)
{
    IOCLR1 = LCD_PORT;
    IOSET1 = ((unsigned int)ch << LCD_SHIFT);
    IOCLR0 = RS;
    IOCLR0 = RW;
    LCD_strobe();
    
    if (ch == 0x01 || ch == 0x02)
    {
        delay(20);
    }
    else
    {
        delay(2);
    }
}

void LCD_init(void)
{
    PINSEL0 &= ~(3U<<20);
    PINSEL0 &= ~(3U<<22);
    PINSEL1 &= ~(3U<<8);
    PINSEL2 = 0x00000000;
    
    IODIR0 |= (EN | RS | RW);
    IODIR1 |= LCD_PORT;
    
    IOCLR0 = (EN | RS | RW);
    IOCLR1 = LCD_PORT;
    delay(200);
    
    LCD_cmd(0x38);
    LCD_cmd(0x06);
    LCD_cmd(0x0C);
    LCD_cmd(0x01);
    LCD_cmd(0x80);
}

void LCD_display(unsigned int row, unsigned int pos, const char *str)
{
    unsigned char address;
    
    if ((row < 1 || row > 2) || (pos < 1 || pos > 16))
    {
        return;
    }
    
    if (row == 1)
    {
        address = 0x80 + (pos - 1);
    }
    else
    {
        address = 0xC0 + (pos - 1);
    }
    
    LCD_cmd(address);
    
    while (*str != '\0')
    {
        LCD_data((unsigned char)*str);
        str++;
    }
}

int main(void)
{
    LCD_init();
    LCD_display(1, 2, "YASH");
    
    while (1)
    {
    }
}