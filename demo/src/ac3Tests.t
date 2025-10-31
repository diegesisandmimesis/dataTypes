#charset "us-ascii"
//
// ac3Tests.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// It can be compiled via the included makefile with
//
//	# t3make -f ac3Tests.t3m
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
		local g;

		g = new AC3();

		g.addVariable('x', [ 0, 1, 2, 3, 4, 5 ]);
		g.addVariable('y', [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
		g.addConstraint('x', { x: !(x % 2) });
		g.addConstraint('x', 'y', { x, y: ((x + y) == 4) });

		if(g.solve() != true) {
			"ERROR: failed to solve constraint satisfaction
				problem\n ";
			return;
		}
		g.forEachVariable({ x: "\n<<x.vertexID>>:
			<<toString(x.domain)>>\n " });
	}
;
