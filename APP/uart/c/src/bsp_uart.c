#include "bsp_uart.h"

struct uart_dev uart_d;

speed_t speed_arr[] =
{
    B115200, B38400, B19200, B9600, B4800, B2400, B1200, B300,
};


static void UART_Config(void)
{
    uart_d.fd = open(UART_DEVICE, O_RDWR);
    if(uart_d.fd < 0)
    {
        printf("failt to open %s\n", UART_DEVICE);
        exit (1);       
    }
}

/**
*@brief  设置串口通信的数据位长度
*@param  fd     类型 int  打开串口的文件句柄
*@param  databits  类型 UART_WordLength_Type  串口数据位长度
*@return  int
*/
int UART_Set_WordLength(int fd, UART_WordLength_Type databits)
{
    struct termios opt;
    int res = 0;
    tcgetattr(fd, &opt);
    //清空标志位
    opt.c_cflag &= ~CSIZE;

    switch (databits)
    {
        case UART_WordLength_5:
            opt.c_cflag |= CS5;
            break;
        case UART_WordLength_6:
            opt.c_cflag |= CS6;
            break;
        case UART_WordLength_7:
            opt.c_cflag |= CS7;
            break;
        case UART_WordLength_8:
            opt.c_cflag |= CS8;
            break;
        default:
            printf("Unsupported data size: %d\n", databits);
            return FALSE;
    }
    tcflush (fd, TCIFLUSH);
    res = tcsetattr(fd, TCSANOW, &opt);
    if(res < 0)
    {
            printf("failed to set wordlength\n");
            return FALSE ;        
    }
    return TRUE;
}
/**
*@brief  设置串口通信的停止位
*@param  fd     类型 int  打开串口的文件句柄
*@param  databits  类型UART_StopBits_Type 串口停止位长度
*@return  int
*/
int UART_Set_StopBits(int fd, UART_StopBits_Type stopbits)
{
    struct termios opt;
    int res = 0;
    tcgetattr(fd, &opt);

    switch (stopbits)
    {
        case UART_StopBits_1:
            opt.c_cflag  &= ~CSTOPB;
            break;
        case UART_StopBits_2:
            opt.c_cflag |= CSTOPB;
        default:
            printf("Unsupported stopbits: %d\n", stopbits);
            break;
    }

    tcflush (fd, TCIFLUSH);
    res = tcsetattr(fd, TCSANOW, &opt);
    if(res < 0)
    {
            printf("failed to set wordlength\n");
            return FALSE ;        
    }
    return TRUE;
}
/**
*@brief  设置串口通信的校验位
*@param  fd     类型 int  打开串口的文件句柄
*@param  databits  类型UART_Parity_Type 串口校验位方式
*@return  int
*/
int UART_Set_Parity(int fd, UART_Parity_Type parity)
{
    struct termios opt;
    int res = 0;
    tcgetattr(fd, &opt);

    switch (parity)
    {
    case UART_Parity_No:
        opt.c_cflag &= ~PARENB;
        opt.c_iflag  &= ~INPCK;
        break;
    case UART_Parity_Odd:
        opt.c_cflag |= PARENB;
        opt.c_cflag |= PARODD;
        opt.c_iflag  |= INPCK;
    case UART_Parity_Even:
        opt.c_cflag |= PARENB;
        opt.c_cflag &= ~PARODD;
        opt.c_iflag  |= INPCK;
    default:
        break;
    }
    tcflush(fd, TCIOFLUSH);
    res = tcsetattr(fd, TCSANOW, &opt);
    if(res < 0)
    {
        printf("failed to set parity\n");
        return FALSE;
    }
    return TRUE;
}

/**
*@brief  设置串口通信速率
*@param  fd     类型 int  打开串口的文件句柄
*@param  speed  类型 int  串口速度
*@return  void
*/
void UART_Set_Baudrate(int fd,  speed_t speed)
{
    struct termios opt;
    int res = 0;
    //清空接收发送缓冲区
    tcflush(fd, TCIOFLUSH);
    //读取当前串口的参数
    tcgetattr(fd, &opt);
    for(int i = 0; i < sizeof(speed_arr)/sizeof(speed_arr[0]); i++)
    {
        if(speed == speed_arr[i])
        {
            //设置输入波特率
            cfsetispeed(&opt, speed_arr[i]);
            //设置输出波特率
            cfsetospeed(&opt, speed_arr[i]);
            //更新配置
            res = tcsetattr(fd, TCSANOW, &opt);
            if(res < 0)
            {
                printf("failed to set baudrate\n");
                return ;
            }

        }
    }
    tcflush(fd, TCIOFLUSH);
}



void UART_Init(void)
{
    UART_Config();
    UART_Set_Baudrate(uart_d.fd, UART_BAUDRATE);
     UART_Set_WordLength(uart_d.fd, UART_WordLength_8);
     UART_Set_StopBits(uart_d.fd, UART_StopBits_1);
     UART_Set_Parity(uart_d.fd, UART_Parity_No);
}

ssize_t UART_Send_Date(char *buf, int len)
{
        return write(uart_d.fd, buf,  len);
}

ssize_t UART_Rece_Date(char *buf, int len)
{
    ssize_t res = 0;
    res = read(uart_d.fd, buf, len);
    return res;
}

void UART_DeInit(void)
{
    close(uart_d.fd);
}
