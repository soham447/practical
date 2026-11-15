#include <lpc214x.h>

#define LCD_PORT 0x00FF0000

#define EN (1<<10)
#define RS (1<<11)
#define RW (1<<20)
#define LCD_SHIFT 16

#define Col0 (1<<12)
#define Col1 (1<<13)
#define Col2 (1<<14)
#define Col3 (1<<15)

#define Row0 (1<<16)
#define Row1 (1<<17)
#define Row2 (1<<18)
#define Row3 (1<<19)

unsigned int ROW[] = {Row0, Row1, Row2, Row3};
unsigned int COL[] = {Col0, Col1, Col2, Col3};

unsigned int KeyCodes[] = {
    '1', '4', '7', '*',
    '2', '5', '8', '0',
    '3', '6', '9', '#',
    'A', 'B', 'C', 'D'
};

void delay(unsigned int time)
{
    int i, j;

    for(i = 0; i < time; i++)
        for(j = 0; j < 200; j++);
}

void LCD_strobe()
{
    delay(100);
    IOSET0 = EN;
    delay(100);
    IOCLR0 = EN;
    delay(100);
}

void LCD_data(unsigned char ch)
{
    IOCLR1 = LCD_PORT;
    IOSET1 = ch << LCD_SHIFT;
    IOSET0 = RS;
    IOCLR0 = RW;
    LCD_strobe();
}

void LCD_cmd(unsigned char ch)
{
    IOCLR1 = LCD_PORT;
    IOSET1 = ch << LCD_SHIFT;
    IOCLR0 = RS;
    IOCLR0 = RW;
    LCD_strobe();
}

void LCD_init(void)
{
    PINSEL0 &= 0xFF0FFFFF;
    PINSEL1 &= 0xFFFFFCFF;
    PINSEL2 &= 0xFFFFFFF3;

    IODIR0 |= RS | EN | RW;
    IODIR1 |= LCD_PORT;

    LCD_cmd(0x38);
    LCD_cmd(0x06);
    LCD_cmd(0x0C);
    LCD_cmd(0x01);
    LCD_cmd(0x80);
}

void LCD_display(int row, int pos, unsigned char *ch)
{
    unsigned char temp;

    if(row == 1)
    {
        temp = 0x80 | (pos - 1);
    }
    else
    {
        temp = 0xC0 | (pos - 1);
    }

    LCD_cmd(temp);

    while(*ch)
        LCD_data(*ch++);
}

void kbddelay(unsigned int time)
{
    int i, j;

    for(i = 0; i < time; i++)
        for(j = 0; j < 100; j++);
}

void kbdInit(void)
{
    PINSEL0 &= 0x00FFFFFF;
    PINSEL1 &= 0xFFFFFF00;

    IODIR0 &= ~0x000FF000;
    IODIR0 |= 0x0000F000;

    IOSET0 = 0x0000F000;
}

unsigned char GetKey(void)
{
    unsigned int col, rowdata, count = 0;
    unsigned char key;

    for(col = 0; col < 4; col++)
    {
        IOCLR0 = COL[col];

        rowdata = IOPIN0;
        kbddelay(100);
        rowdata = IOPIN0;
        rowdata >>= 16;

        if((rowdata & 0x0F) != 0x0F)
        {
            for(count = 0; count < 4; count++)
            {
                if((rowdata & 0x01) == 0)
                {
                    key = KeyCodes[(col * 4) + count];

                    IOSET0 = COL[col];

                    return key;
                }

                rowdata >>= 1;
            }
        }

        IOSET0 = COL[col];
    }

    return 0;
}

int main()
{
    unsigned char temp;

    kbdInit();
    LCD_init();

    LCD_display(1, 1, "Keypad");

    while(1)
    {
        temp = GetKey();

        if(temp != 0)
        {
            LCD_cmd(0xC0);
            LCD_data(temp);
        }
    }
}
