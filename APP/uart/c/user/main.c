#include <stdio.h>
#include "bsp_uart.h"

#define MAX_NUMS                256

char w_buf[] = "Embedfire i.mx6ull uart demo\n";
char r_buf[MAX_NUMS];

int main(int argc, char *argv[])
{
    printf("This is UART demo\n");
    UART_Init();
    //不发送字符串数组的结束符
    UART_Send_Date(w_buf, sizeof(w_buf)/sizeof(w_buf[0])-1);

    UART_Rece_Date(r_buf, MAX_NUMS);

    printf("%s", r_buf);

    UART_DeInit();

    return 0;
}