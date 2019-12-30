#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
//音乐文件列表，大小需要根据SD卡的内容调整
char music_ls[1000];
//命令
char cmdstr[100];

int main(void)
{
    //文件指针，用于接收管道数据
    FILE *fp;
    printf("This is the music demo\n");
    //挂载SD卡
   //system("mount /dev/mmcblk0 /media");
   //使用popen函数接收find的执行结果，
   //第二个参数‘r’表示从标准输出读取数据
   //xargs用于删除执行结果的换行符
    fp = popen("find /run -name *.mp3 | xargs", "r");
    if(fp == NULL)
        printf("fail to open\n");
    //读取文件内容，这里能够读取到命令的执行结果
    fgets(music_ls, 1000, fp);
	//关闭文件
    pclose(fp);
    //执行播放命令
     sprintf(cmdstr,"gplay-1.0 %s", music_ls);
     system(cmdstr);
     //取消SD卡的挂载
     system("umount /media");
    return 0;
}
