#charset "us-ascii"
//
// vectorMathTests.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// It can be compiled via the included makefile with
//
//	# t3make -f vectorMathTests.t3m
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


		err = 0;

		v0 = new Vector([ 1, 3, -5 ]);
		v1 = new Vector([ 4, -2, -1 ]);
		if((v0.dot(v1) != 3) || (v0.dot(v0) != 35)) {
			"\nERROR: vector dot product test failed\n ";
			err += 1;
		}

		v0 = [ 1, 3, -5 ];
		v1 = [ 4, -2, -1 ];
		if((v0.dot(v1) != 3) || (v0.dot(v0) != 35)) {
			"\nERROR: list dot product test failed\n ";
			err += 1;
		}

		v0 = new Vector([ 1, 3, 5 ]);
		v1 = new Vector([ 7, 11, 13 ]);
		r = new Vector([ 8, 14, 18 ]);
		if(!v0.add(v1).equals(r) || !v1.add(v0).equals(r)) {
			"\nERROR: vector addition test failed\n ";
			err += 1;
		}

		v0 = [ 1, 3, 5 ];
		v1 = [ 7, 11, 13 ];
		r = [ 8, 14, 18 ];
		if(!v0.add(v1).equals(r) || !v1.add(v0).equals(r)) {
			"\nERROR: list addition test failed\n ";
			err += 1;
		}

		v0 = new Vector([ 8, 14, 18 ]);
		v1 = new Vector([ 7, 11, 13 ]);
		r = new Vector([ 1, 3, 5 ]);
		if(!v0.subtract(v1).equals(r) || !v0.subtract(r).equals(v1)) {
			"\nERROR: vector subtraction test failed\n ";
			err += 1;
		}

		v0 = [ 8, 14, 18 ];
		v1 = [ 7, 11, 13 ];
		r = [ 1, 3, 5 ];
		if(!v0.subtract(v1).equals(r) || !v0.subtract(r).equals(v1)) {
			"\nERROR: list subtraction test failed\n ";
			err += 1;
		}

		v0 = new Vector([ 1, 2, 3 ]);
		r = new Vector([ 2, 4, 6 ]);
		if(!v0.multiply(2).equals(r)) {
			"\nERROR: vector multiplication test failed\n ";
			err += 1;
		}

		v0 = [ 1, 2, 3 ];
		r = [ 2, 4, 6 ];
		if(!v0.multiply(2).equals(r)) {
			"\nERROR: list multiplication test failed\n ";
			err += 1;
		}

		v0 = new Vector([ 2, 4, 6 ]);
		r = new Vector([ 1, 2, 3 ]);
		if(!v0.divide(2).equals(r)) {
			"\nERROR: vector division test failed\n ";
			err += 1;
		}

		v0 = [ 2, 4, 6 ];
		r = [ 1, 2, 3 ];
		if(!v0.divide(2).equals(r)) {
			"\nERROR: list division test failed\n ";
			err += 1;
		}

		v0 = new Vector([ 1, 3, 5 ]);
		v1 = new Vector([ 7, 11, 13 ]);
		r = new Vector([ 8, 14, 18 ]);
		if(!v0.add(v1).equals(r)) {
			"\nERROR: vector in-place addition test failed\n ";
			err += 1;
		}

		v0 = new Vector([ 8, 14, 18 ]);
		v1 = new Vector([ 7, 11, 13 ]);
		r = new Vector([ 1, 3, 5 ]);
		if(!v0.subtract(v1).equals(r)) {
			"\nERROR: vector in-place subtraction test failed\n ";
			err += 1;
		}

		v0 = new Vector([ 1, 2, 3 ]);
		r = new Vector([ 2, 4, 6 ]);
		if(!v0.imultiply(2).equals(r)) {
			"\nERROR: vector in-place multiplication test failed\n ";
			err += 1;
		}

		v0 = new Vector([ 2, 4, 6 ]);
		r = new Vector([ 1, 2, 3 ]);
		if(!v0.idivide(2).equals(r)) {
			"\nERROR: vector in-place division test failed\n ";
			err += 1;
		}

		v0 = new Vector([ 1, 3, -5 ]);
		r = new Vector([ 1, 3, 0 ]);
		if(!v0.relu().equals(r)) {
			"\nERROR: relu test failed\n ";
			err += 1;
		}

		if(err == 0)
			"\npassed all tests\n ";
		else
			"\nFAILED <<toString(err)>> tests\n ";
	}
;
