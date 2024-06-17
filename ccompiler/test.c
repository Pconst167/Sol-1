#include <stdio.h>

char currState[50][50];

void main(){
  int i;
  int j;
  int n;

  for(i=0;i<50;i++){
    for(j=0;j<50;j++){
      n = neighbours(i, j);
      printf("%d\n", n);
    }
  }
}

int neighbours(int i, int j){
	int count;
  
	count = 0;

	if(currState[i+-1][j] == '@')			count++;
	if(currState[i+-1][j+-1] == '@') 	count++;
	if(currState[i+-1][j+1] == '@') 	count++;
	if(currState[i][j+-1] == '@') 		count++;
	if(currState[i][j+1] == '@') 			count++;

	if(currState[i+1][j+-1] == '@') 	count++;
	if(currState[i+1][j] == '@') 			count++;
	if(currState[i+1][j+1] == '@') 		count++;

	return count;
}