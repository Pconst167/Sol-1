struct _FILE{
  int handle;
  int filename[256];
  int mode; // 0: RD, 1: WR, 2: RW, 3: APPEND
  int loc; // position of seek head
};
typedef struct _FILE FILE;

FILE *fopen(char *filename, int mode){
  FILE *fp;

 sizeof(FILE);
}

void main(){

}