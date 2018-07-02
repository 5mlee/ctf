#define _GNU_SOURCE
#include <ncurses.h>
#include <stdlib.h>
#include <unistd.h>
#include <dlfcn.h>
#include <stdio.h>

typedef int (*origin_wgetch)(WINDOW*);

int count = 0;

int wgetch(WINDOW *win){
	char *line = 0x0000000000607648;
	char key[] = {'d','f','j','k'};

	for(int i = 0; i < 4; i++){
		if(line[i] == 'o' && ++count >= 20){
				count = 0;
				return key[i];
		}
	}

	origin_wgetch _wgetch = (origin_wgetch)dlsym(RTLD_NEXT, "wgetch");
	return _wgetch(win);
}
