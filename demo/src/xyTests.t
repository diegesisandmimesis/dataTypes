#charset "us-ascii"
//
// xyTests.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// It can be compiled via the included makefile with
//
//	# t3make -f xyTests.t3m
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
		local err, v0, v1, r;

		err = 0;

		v0 = new XY(1, 1);
		v1 = new XY(1, 1);

		r = v0 + v1;
		if(r.equals(new XY(2, 2)) != true) {
			"\nERROR: addition test failed\n ";
			err += 1;
		}

		r = r * 2;
		if(r.equals(new XY(4, 4)) != true) {
			"\nERROR: multiplication test failed\n ";
			err += 1;
		}

		r = r / 2;
		if(r.equals(new XY(2, 2)) != true) {
			"\nERROR: division test failed\n ";
			err += 1;
		}

		if(err == 0) {
			"passed all tests\n ";
		}
	}
;
