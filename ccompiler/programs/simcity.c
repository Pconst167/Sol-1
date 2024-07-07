#include <stdio.h>
#include <stdlib.h>

#define NUM_COLS  38
#define NUM_ROWS 20

enum tile_type {land, water};
enum zone_type {unzoned, residential, commercial, industrial};
enum structure_type {road, small_house0, small_house1, large_house0};

typedef enum tile_type tiletype;
typedef enum zone_type zonetype;

struct tile{
  enum tile_type tile_type;
  enum zone_type zone_type;
  enum structure_type structure_type;
};

struct tile map[NUM_ROWS][NUM_COLS];


void main(){
  char c;

  initialize_terrain();

  for(;;){
    display_map();
    move_cursor(0, 39);
    printf("\nd: display map\nq: quit\nenter choice: ");
    c = getchar();
    if(c == 'q'){
      return;
    }
  }
}

void display_map(){
  int rows, cols;

  for(rows = 0; rows < NUM_ROWS; rows++){
    for(cols = 0; cols < NUM_COLS; cols++){
      move_cursor(cols, rows);
      if(map[rows][cols].zone_type == unzoned){
        if(map[rows][cols].tile_type == land){
          putchar('.');
        }
        else if(map[rows][cols].tile_type == water){
          putchar('~');
        }
      }
      else{
        if(map[rows][cols].zone_type == residential){
          putchar('R');
        }
        else if(map[rows][cols].zone_type == commercial){
          putchar('C');
        }
        else if(map[rows][cols].zone_type == industrial){
          putchar('I');
        }
      }
    }
    putchar('\n');
  }
}

void initialize_terrain(){
  int i, j;

  for(i = 0; i < NUM_ROWS; i++){
    for(j = 0; j < NUM_COLS; j++){
      map[i][j].structure_type = -1;
      map[i][j].zone_type = unzoned;
      map[i][j].tile_type = land;
    }
  }

  map[5][5].zone_type  = residential;
  map[5][6].zone_type  = residential;
  map[5][7].zone_type  = residential;
  map[6][5].zone_type  = commercial;
  map[6][6].zone_type  = commercial;
  map[6][7].zone_type  = commercial;
  map[6][8].zone_type  = commercial;
  map[10][5].zone_type = industrial;
  map[10][6].zone_type = industrial;
  map[11][6].zone_type = industrial;
  map[11][7].zone_type = industrial;
}