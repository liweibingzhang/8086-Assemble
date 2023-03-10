#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define max 100
typedef struct position
{
  int x;
  int y;
} POSITION, *LPPOSITION;
POSITION path_stack[max];
int stack_top = -1;
int **maze = NULL;
int size;
int **make_array(int rows, int cols)
{
  int **array = (int **)malloc(sizeof(int *) * rows);
  for (int i = 0; i < rows; i++)
  {
    array[i] = (int *)malloc(sizeof(int) * cols);
  }
  return array;
}
// 创建一个地图
void create_map()
{
  int size = 15;
  maze = make_array(size + 2, size + 2);
  // 周围搞一圈数字“1”的墙
  for (int i = 0; i <= size + 1; i++)
  {
    maze[0][i] = maze[size + 1][i] = 1;
    maze[i][0] = maze[i][size + 1] = 1;
  }
  for (int i = 1; i <= size; i++)
  {
    for (int j = 1; j <= size; j++)
    {
      if (1 == i && 1 == j)
        maze[i][j] = 0;
      else
      {
        switch (rand() % 8)
        {
        case 0:
        case 1:
          maze[i][j] = 1;
          break;
        default:
          maze[i][j] = 0;
          break;
        }
      }
      printf("%d\t", maze[i][j]);
    }
    printf("\n\n");
  }
}
int find_path()
{
	//4个方向的位移变化
	POSITION offset[4];
	//以右边顺时针开始
	offset[0].x = 0;//右边
	offset[0].y = 1;
	offset[1].x = 1;//下
	offset[1].y = 0;
	offset[2].x = 0;//左边
	offset[2].y = -1;
	offset[3].x = -1;//up
	offset[3].y = 0;
	//路口选定为：迷宫左上角
	// ....0可走，1为墙....
	POSITION here = { 1,1 };
	//....走过的地方给它堵住...
	maze[1][1] = 1;
	int option = 0;//从右边顺时针往左
	int last_option = 3;
	while (here.x != size || here.y != size)
	{
		int row, col;//记录下标的变化
		while (option <= last_option)
		{
			row = here.x + offset[option].x;
			col = here.y + offset[option].y;
			if (maze[row][col] == 0)
				break;
			option++;
		}
		//能走与不能走的情况
		//能走
		if (option <= last_option)
		{
			path_stack[++stack_top] = here;
			here.x = row;
			here.y = col;
			maze[row][col] = 1;
			option = 0;//下一个位置依旧从右边试探
		}
		//不能走应该怎么办？
		else
		{
			if (stack_top == -1)
			{
				return 0;
			}
			//退回上一步位置，一直不能走就一直退
			POSITION next = path_stack[stack_top];
			stack_top--;
			option = 0;
			here = next;
		}

	}
	return 1;
}
void print_path()
{
	printf("path:\n");
	for (int i = 0; i <= stack_top; i++)
	{
		printf("(%d,%d)\t", path_stack[i].x, path_stack[i].y);
	}
	printf("(%d,%d)", size, size);
}
int main()
{
	srand((unsigned int)time(0));
	create_map();
	if (find_path())
	{
		print_path();
	}
	else
	{
		printf("This maze has no out");
	}
	return 0;
}
