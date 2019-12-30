#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

char cmdout[100];

int main(void)
{
    unsigned int  ADC_ConvertedValue = 0;
    float ADC_ConvertedValueLocal = 0;  //保存转换得到的电压值
    FILE *fp;
    printf("This is the adc demo\n");
    while(1)
    {
        fp = popen("cat /sys/bus/iio/devices/iio\\:device0/in_voltage3_raw", "r");
        if(fp == NULL)
            printf("Fail to open\n");

        fgets(cmdout, 100, fp);
        pclose(fp);       
        ADC_ConvertedValue = atoi(cmdout);
        /*输出原始转换结果*/
        printf("The Conversion Value: %d\r\n", ADC_ConvertedValue);

        ADC_ConvertedValueLocal = ((float)ADC_ConvertedValue)/4095.0f*3.3f;
         /*将结果转换为电压值并通过串口输出*/
        printf("The current AD value = %f V \r\n",ADC_ConvertedValueLocal);
        
        sleep(1);
    }

    return 0;
}
