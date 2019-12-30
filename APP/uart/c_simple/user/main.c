#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <termios.h>
#include <string.h>

#define UART_DEV_PATH   "/dev/ttymxc2"
#define SEND_STRING         "Embedfire i.mx6ull uart demo\n"

char r_buf[128];

int main(int argc, char *argv[])
{
    int fd;
    struct termios opt;
    //获取串口设备描述符
    printf("This is UART demo\n");
    fd = open(UART_DEV_PATH, O_RDWR);
    if(fd < 0)
    {
        printf("Fail to Open %s device\n", UART_DEV_PATH);
        exit(1);
    }
    //清空缓冲区
    tcflush(fd, TCIOFLUSH);
    //获取串口参数opt
    tcgetattr(fd, &opt);
    //设置串口输出波特率
    cfsetospeed(&opt, B115200);
    //设置串口输入波特率
    cfsetispeed(&opt, B115200);
    //设置8位数据位
    opt.c_cflag &= ~CSIZE;
    opt.c_cflag |= CS8;
    //设置1位停止位
    opt.c_cflag &= ~CSTOPB;
    //无校验位
    opt.c_cflag &= ~PARENB;
    opt.c_iflag &= ~INPCK;
    //更新配置
    tcsetattr(fd, TCSANOW, &opt);    
    //串口发送字符串
    write(fd, SEND_STRING, strlen(SEND_STRING));
    //接收字符串
    read(fd, r_buf, 128);
    
    printf("receive : %s", r_buf);

    close(fd);
    return 0;
}