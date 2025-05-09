#charset "us-ascii"
//
// quadTreeTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// It can be compiled via the included makefile with
//
//	# t3make -f quadTreeTest.t3m
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
	size = 10

	newGame() {
		local i, v, t;

		t = new QuadTree(0, 0, size, size);
		for(i = 1; i <= size; i++) {
			t.insert(i, i, 'foo' + toString(i));
		}

		for(i = 1; i <= size; i++) {
			v = new XY(i, i);
			"\n<<v.toStr()>>:\n ";
			t.query(v).forEach({ x: "\n\t<<x>>\n " });
		}

		v = new Rectangle(1, 1, 4, 4);
		t.query(v).forEach({ x: "\n<<x>>\n " });
	}
;
