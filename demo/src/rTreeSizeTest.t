#charset "us-ascii"
//
// rTreeSizeTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// It can be compiled via the included makefile with
//
//	# t3make -f rTreeSizeTest.t3m
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
		local i, r, t;

		t = new RTree();

		for(i = 0; i < 1000; i++) {
			t.insert(rand(10000) + 1, rand(10000) + 1,
				'foo' + toString(i));
		}

		for(i = 0; i < 1000; i++) {
			r = t.query(rand(10000) + 1, rand(10000) + 1);
			if(r) {}
		}
	}
;
