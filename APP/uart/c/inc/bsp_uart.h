#ifndef  _BSP_UART_H_
#define _BSP_UART_H_

#include <stdio.h>                          //standard input & output，标准输入输出，经常使用的printf函数，scanf函数
#include <stdlib.h>                         //standard library，标准输入输出库，包含malloc函数、free函数
#include <unistd.h>                         //POSIX系统接口头文件
#include <fcntl.h>                          //文件接口头文件
#include <sys/types.h>                      //系统基础数据类型
#include <sys/stat.h>                       //定义文件的状态
#include <termios.h>                        //Linux串口头文件
#include <errno.h>                          //错误码头文件，定义了一些错误宏定义

#define UART_DEVICE         "/dev/ttymxc2"
#define UART_BAUDRATE  B115200

#define TRUE                            1
#define FALSE                           0

typedef enum UART_StopBits_n
{
    UART_StopBits_1 = 1,
    UART_StopBits_2 = 2,
}UART_StopBits_Type;

typedef enum UART_WordLength_n
{
    UART_WordLength_5 = 5,
    UART_WordLength_6,
    UART_WordLength_7,
    UART_WordLength_8,
}UART_WordLength_Type;

typedef enum UART_Parity_x
{
    UART_Parity_No = 0,
    UART_Parity_Even,
    UART_Parity_Odd,
}UART_Parity_Type;

struct uart_dev
{
    int fd;
};
void UART_Init(void);
void UART_DeInit(void);
ssize_t UART_Send_Date(char *buf, int len);
ssize_t UART_Rece_Date(char *buf, int len);
//设置串口波特率
void UART_Set_Baudrate(int fd,  speed_t speed);

int UART_Set_WordLength(int fd, UART_WordLength_Type databits);

int UART_Set_StopBits(int fd, UART_StopBits_Type stopbits);

int UART_Set_Parity(int fd, UART_Parity_Type parity);
#endif /* _BSP_UART_H_ */