#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#define TREK_DIR	"/usr/lib/trek/"

/* Standard Terminal Sizes */

#define MAXROW      24
#define MAXCOL      80

typedef char int8_t;
typedef unsigned char uint8_t;
typedef int int16_t;

struct klingon {
	uint8_t y;
	uint8_t x;
	int16_t energy;
};

/* Function Declarations */


/* Global Variables */
static const int a, g, e;
char b;



int8_t starbases;		/* Starbases in Quadrant */
uint8_t base_y, base_x;		/* Starbase Location in sector */
int8_t starbases_left;		/* Total Starbases */


int main(){
	const int ii;
}