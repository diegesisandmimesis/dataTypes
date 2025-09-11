#charset "us-ascii"
//
// setTheoryTests.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// It can be compiled via the included makefile with
//
//	# t3make -f setTheoryTests.t3m
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
		local err, r, v0, v1;


		v0 = new Vector([ 1, 2, 3, 4, 5, 6 ]);
		v1 = new Vector([ 5, 6, 7, 8, 9 ]);

		err = 0;
		r = v0.union(v1);
		if(!r.equals(new Vector([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]))) {
			"\nERROR:  union test failed\n ";
			err += 1;
		}
		r = v0.intersection(v1);
		if(!r.equals(new Vector([ 5, 6 ]))) {
			"\nERROR:  intersection test failed\n ";
			err += 1;
		}
		r = v0.complement(v1);
		if(!r.equals(new Vector([ 1, 2, 3, 4 ]))) {
			"\nERROR:  compliment test failed\n ";
			err += 1;
		}

		if(err == 0)
			"\npassed all tests\n ";
		else
			"\nFAILED <<toString(err)>> tests\n ";
	}
;
