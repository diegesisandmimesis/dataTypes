#charset "us-ascii"
//
// dijstraTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the Dijstra pathfinding
// logic.
//
// It can be compiled via the included makefile with
//
//	# t3make -f dijstraTest.t3m
//
// ...or the equivalent, depending on what TADS development environment
// you're using.
//
// This "game" is distributed under the MIT License, see LICENSE.txt
// for details.
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

versionInfo: GameID;
gameMain: GameMainDef
	newGame() {
		local l;

		l = graph0.getDijkstraPath('v0', 'v1');
		aioSay('\nPath:\n ');
		aioSay('\n<<toString(l)>>\n ');
		//l.forEach({ x: aioSay('\n\t<<toString(x.vertexID)>>\n ') });
	}
;

// Graph:
//
//	v0 --- foo --- bar
//		 \     /
//		   baz
//		    |
//		   v1
//
graph0: Graph
	[	'v0',	'foo',	'bar',	'baz',	'v1'	]
	[
		0,	1,	0,	0,	0,
		1,	0,	1,	1,	0,
		0,	1,	0,	1,	0,
		0,	1,	1,	0,	1,
		0,	0,	0,	1,	0
	]
;
