#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#define TREK_DIR	"./STAR_TREK"

/* Standard Terminal Sizes */

#define MAXROW      24
#define MAXCOL      80

/*typedef char int8_t;
typedef unsigned char uint8_t;
typedef int int16_t;*/

struct klingon {
	uint8_t y;
	uint8_t x;
	int16_t energy;
};

/* Global Variables */

int8_t starbases;		/* Starbases in Quadrant */
uint8_t base_y, base_x;		/* Starbase Location in sector */
int8_t starbases_left;		/* Total Starbases */

int8_t c[3][10] =	/* Movement indices 1-9 (9 is wrap of 1) */
{
	{0},
	{0, 0, -1, -1, -1, 0, 1, 1, 1, 0},
	{1, 1, 1, 0, -1, -1, -1, 0, 1, 1}
};

uint8_t docked;			/* Docked flag */
int energy;			/* Current Energy */
const int energy0 = 3000;	/* Starting Energy */
unsigned int map[9][9];		/* Galaxy. BCD of k b s plus flag */
#define MAP_VISITED 0x1000		/* Set if this sector was mapped */
struct klingon kdata[3];		/* Klingon Data */
uint8_t klingons;		/* Klingons in Quadrant */
uint8_t total_klingons;		/* Klingons at start */
uint8_t klingons_left;		/* Total Klingons left */
uint8_t torps;			/* Photon Torpedoes left */
const uint8_t torps0 = 10;	/* Photon Torpedo capacity */
int quad_y, quad_x;		/* Quadrant Position of Enterprise */
int shield;			/* Current shield value */
uint8_t stars;			/* Stars in quadrant */
uint16_t time_start;		/* Starting Stardate */
uint16_t time_up;		/* End of time */
int16_t damage[9];		/* Damage Array */
int16_t d4;			/* Used for computing damage repair time */
int16_t ship_y, ship_x;		/* Current Sector Position of Enterprise, fixed point */
uint16_t stardate;		/* Current Stardate */

uint8_t quad[8][8];
#define Q_SPACE		0
#define Q_STAR		1
#define Q_BASE		2
#define Q_KLINGON	3
#define Q_SHIP		4

char quadname[12];		/* Quadrant name */

const char *inc_1 = "reports:\n  Incorrect course data, sir!\n";
const char *quad_name[] = { "",
	"Antares", "Rigel", "Procyon", "Vega", "Canopus", "Altair",
	"Sagittarius", "Pollux", "Sirius", "Deneb", "Capella",
	"Betelgeuse", "Aldebaran", "Regulus", "Arcturus", "Spica"
};
const char *device_name[] = {
	"", "Warp engines", "Short range sensors", "Long range sensors",
	"Phaser control", "Photon tubes", "Damage control", "Shield control",
	"Library computer"
};
const char *dcr_1 = "Damage Control report:";

/* Main Program */

int main(int argc, char *argv[])
{
	//chdir(TREK_DIR);
	intro();

	new_game();

	return (0);
}

/* We probably need double digit for co-ordinate maths, single for time */
int TO_FIXED(int x){
	return x * 10;
}
int FROM_FIXED(int x){
	return x / 10;
}
int TO_FIXED00(int x){
	return x * 100;
}
int FROM_FIXED00(int x){
	return x / 100;
}

/*
 *	Returns an integer from 1 to spread
 */