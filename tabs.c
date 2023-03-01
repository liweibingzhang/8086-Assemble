#include <stdio.h>
#include <string.h>
int main()
{
    char read[100];
    char res[100];
    int tab_num = 0;
    int cnt = 0;
    int read_cnt = 0;
    int res_cnt = 0;
    int temp_res = 0;
    printf("Tab:");
    scanf("%d", &tab_num);
    printf("Read:");
    scanf("%s", &read);
    for (int i = 0; i < strlen(read); i++)
    {
        if (read[read_cnt] != '\t')          // save the character into the res[]
        {                                  
            cnt++;                         // record the number of characters before.
            res[res_cnt] = read[read_cnt]; // put the character into the res
            res_cnt++;
            read_cnt++;
        }
        temp_res = res_cnt;
        if (read[read_cnt] == '\t')
        { // if it is tab, then add space of tab_num-cnt into the res
            for (int j = res_cnt; j < temp_res + tab_num - cnt; j++)
            {
                res[j] = ' ';
                res_cnt++;
            }
            cnt = 0;
            read_cnt++;
        }
    }
    printf("%s", res);
}