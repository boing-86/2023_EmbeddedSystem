#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "tv.h"

#define ITR 4

int main(void)
{
	FILE *fp;
	int i, j, k;
	unsigned int result[4][4] = {0};
	i=0;
    j=0;
    k=0;
	fp = fopen("./sw_result.txt", "w");

    unsigned int ma[4][4] = {a[0], a[1], a[2], a[3],
                             a[4], a[5], a[6], a[7],
                             a[8], a[9], a[10], a[11],
                             a[12], a[13], a[14], a[15]};
    unsigned int mb[4][4] = {b[0], b[1], b[2], b[3],
                            b[4], b[5], b[6], b[7],
                            b[8], b[9], b[10], b[11],
                            b[12], b[13], b[14], b[15]};
	
	if(fp==NULL)
	{
		printf("error occurs when opening sw_result.txt!\n");
		exit(1);
	}
    
    while (i < ITR) {
        j = 0;
        while (j < ITR) {
            k = 0;
            while (k < ITR) {
                result[i][j] = result[i][j] + ma[i][k] * mb[k][j];
                k++;
            }
            fprintf(fp, "%08x", result[i][j]);
            j++;
        }
        i++;
    }
		
	fclose(fp);
	
	return 0;
}
