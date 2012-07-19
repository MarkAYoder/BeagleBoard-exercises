#include <ncurses.h>
#include <stdio.h>
#include <stdlib.h>

// Taken from http://bwgz57.wordpress.com/category/beaglebone/
// Compile with gcc ncurses.c -lncurses -o ncurses

void monitor(FILE *fp) {
        int run = 1;
        int count = 0;

        nodelay(stdscr, true);
        noecho();

        mvprintw(1, 1, "brightness:");
        mvprintw(2, 1, "     count:");

        while (run) {
                char buffer[16];
                memset(buffer, 0, sizeof(buffer));

                fseek(fp, 0, 0);
                fread(buffer, sizeof(char), sizeof(buffer), fp);

                int value = atoi(buffer);
                if (value != 0) {
                        count++;
                }

                mvprintw(1, 12, "%-3s", (value != 0 ? "on" : "off"));
                mvprintw(2, 12, "%d", count);

                int c = getch();
                switch(c) {
                        case 'q':
                                run = 0;
                                break;
                }
        }
}

void main() {
        char *file = "/sys/class/leds/beagleboard::usr0/brightness";
        FILE *fp;
        if ((fp = fopen(file, "r")) == NULL) {
                fprintf(stderr, "error: cannot open %s\n", file);
        }
        else {
                initscr();
                monitor(fp);
                endwin();

                fclose(fp);
        }
}

