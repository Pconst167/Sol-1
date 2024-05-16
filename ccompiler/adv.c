/*
 * 'cheat' is a tool for generating save game files to test states that ought
 * not happen. It leverages chunks of advent, mostly initialize() and
 * savefile(), so we know we're always outputting save files that advent
 * can import.
 *
 * SPDX-FileCopyrightText: 1977, 2005 by Will Crowther and Don Woods
 * SPDX-FileCopyrightText: 2017 by Eric S. Raymond
 * SPDX-License-Identifier: BSD-2-Clause
 */
#include <stdio.h>
#define EOF 1
#define stderr 1
#define EXIT_SUCCESS 1

struct game_t{
  char saved;
  char numdie;
  char limit;
  char turns;
} game;

struct save_t{
  char version;
} save;

int savefile(struct FILE fp){

}

int fprintf(int stderrs, char *usage, char **argv){

}

void initialise(){

}

char getopt(int i, char **c, int opts){

}


int main(int argc, char *argv[])
{
    int ch;
    char *savefilename;
    struct FILE *fp;
    char *optarg;

    // Initialize game variables
    initialise();

    /* we're generating a saved game, so saved once by default,
     * unless overridden with command-line options below.
     */
    game.saved = 1;

    /*  Options. */
    char* opts;
    char* usage;
    opts = "d:l:s:t:v:o:";
    usage = "Usage: %s [-d numdie] [-s numsaves] [-v version] -o savefilename \n";

    while ((ch = getopt(argc, argv, opts)) != EOF) {
        switch (ch) {
        case 'd':
            game.numdie = atoi(optarg);
            printf("cheat: game.numdie = %d\n", game.numdie);
            break;
        case 'l':
            game.limit = atoi(optarg);
            printf("cheat: game.limit = %d\n", game.limit);
            break;
        case 's':
            game.saved = (int)atoi(optarg);
            printf("cheat: game.saved = %d\n", game.saved);
            break;
        case 't':
            game.turns = atoi(optarg);
            printf("cheat: game.turns = %d\n", game.turns);
            break;
        case 'v':
            save.version = atoi(optarg);
            printf("cheat: version = %d\n", save.version);
            break;
        case 'o':
            savefilename = optarg;
            break;
        default:
            fprintf(1, usage, argv[0]);
            exit();
            break;
        }
    }

    // Save filename required; the point of cheat is to generate save file
    if (savefilename == NULL) {
        fprintf(stderr,
                usage, argv[0]);
        fprintf(stderr,
                "ERROR: filename required\n", 1);
        exit();
    }

    fp = fopen(savefilename, 1);
    if (fp == NULL) {
        fprintf(stderr,
                "Can't open file %s. Exiting.\n", savefilename);
        exit();
    }

    savefile(fp);

    fclose(fp);

    printf("cheat: %s created.\n", savefilename);

    return EXIT_SUCCESS;
}