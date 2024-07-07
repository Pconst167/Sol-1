#include <stdio.h>
#include <stdlib.h>

#define NUM_COLS  40
#define NUM_ROWS 30

enum tile_type {land, water};
enum zone_type {unzoned, residential, comercial, industrial};
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

  initialize_terrain();

    display_map();



}

void display_map(){
  int rows, cols;

  for(rows = 0; rows < NUM_ROWS; rows++){
    for(cols = 0; cols < NUM_COLS; cols++){
      printf("%d ", map[rows][cols].structure_type);
      /*
      if(map[rows][cols].tile_type == land){
        putchar('.');
      }
      else if(map[rows][cols].tile_type == water){
        putchar('~');
      }
      else{
        if(map[rows][cols].structure_type == road){
          putchar('=');
        }
      }*/
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
}