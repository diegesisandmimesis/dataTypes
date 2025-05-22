#charset "us-ascii"
//
// integerMatrixTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// Tests of IntegerMatrix.
//
// It can be compiled via the included makefile with
//
//	# t3make -f integerMatrixTest.t3m
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

// Datatype to hold our tests.
class DetTest: object det = nil matrix = nil;

// Subclasses.  Used entirely so we can use forEachInstance to iterate over
// them.
class DetTest2x2: DetTest;
class DetTest3x3: DetTest;

// Test template.
DetTest template +det? [ matrix ]?;

// Datatype to hold matrix multiplication tests.
class MultTest: object d0 = nil m0 = nil d1 = nil m1 = nil dr = nil mr = nil;
MultTest template [ d0 ] [ m0 ] [ d1 ] [ m1 ] [ dr ] [ mr ];

// The 2x2 matrix tests.
DetTest2x2 +5 [
	3, 2,
	2, 3
];
DetTest2x2 +14 [
	4, 6,
	3, 8
];

// 3x3 matrix tests.
DetTest3x3 +(-306) [
	6, 1, 1,
	4, -2, 5,
	2, 8, 7
];
DetTest3x3 +(-11) [
	1, 3, 0,
	4, 1, 0,
	2, 0, 1
];

// Multiplication tests
MultTest
	[ 3, 2 ] [ 1, 2, 3, 4, 5, 6 ]
	[ 2, 3 ] [ 7, 8, 9, 10, 11, 12 ]
	[ 2, 2 ] [ 58, 64, 139, 154 ]
;
MultTest
	[ 3, 1 ] [ 3, 4, 2 ]
	[ 4, 3 ] [ 13, 9, 7, 15, 8, 7, 4, 6, 6, 4, 0, 3 ]
	[ 4, 1 ] [ 83, 63, 37, 75 ]
;


versionInfo: GameID;
gameMain: GameMainDef
	newGame() {
		if(determinantTest2x2() && determinantTest3x3()
			&& multiplicationTest())
			"\npassed all tests\n ";
	}

	// Run a set of tests.
	// First arg is the label for this kind of test (for error logging
	// if needed).  Second arg is the test class.
	_runTest(lbl, cls) {
		local err;

		err = 0;

		forEachInstance(cls, function(tst) {
			local m;

			m = new IntegerMatrix();
			if(!m.load(tst.matrix)) {
				"\nERROR:  <<lbl>> failed to load\n ";
				err += 1;
				return;
			}

			if(m.determinant() != tst.det) {
				"\nERROR:  <<lbl>> check failed\n ";
				err += 1;
			}
		});

		if(err > 0)
			return(nil);

		return(true);
	}

	determinantTest2x2() {
		return(_runTest('2x2 determinant test', DetTest2x2));
	}

	determinantTest3x3() {
		return(_runTest('3x3 determinant test', DetTest3x3));
	}

	multiplicationTest() {
		local err;

		err = 0;

		forEachInstance(MultTest, function(cfg) {
			local m0, m1, mr, r;

			m0 = new IntegerMatrix(cfg.d0[1], cfg.d0[2]);
			m1 = new IntegerMatrix(cfg.d1[1], cfg.d1[2]);
			m0.load(cfg.m0);
			m1.load(cfg.m1);

			r = m0.multiply(m1);

			mr = new IntegerMatrix(cfg.dr[1], cfg.dr[2]);
			mr.load(cfg.mr);

			if(!r.equals(mr))
				err += 1;
		});

		return(err == 0);
	}
;
