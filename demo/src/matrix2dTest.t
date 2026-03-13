#charset "us-ascii"
//
// matrix2dTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// Simple test of the basic functionality of the Matrix class.
//
// Creates a couple of matrices, inserts values and then queries them.
//
// It can be compiled via the included makefile with
//
//	# t3make -f matrix2dTest.t3m
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
	// Matrix width.
	matrixSize = 3

	newGame() {
		if(test2D && testAsymmetric() && testOOB()
			&& testTranspose()) {
			"\npassed all tests\n ";
		} else {
			"\nERROR: failed one or more tests\n ";
		}
	}

	// Test a simple two axis matrix.
	test2D() {
		local err, i, j, n, m, sz;

		sz = matrixSize;
		m = new Matrix2D(sz, sz);
		n = 0;

		for(j = 1; j <= sz; j++) {
			for(i = 1; i <= sz; i++) {
				n += 1;
				m.set(i, j, n);
			}
		}

		err = 0;
		n = 0;
		for(j = 1; j <= sz; j++) {
			for(i = 1; i <= sz; i++) {
				n += 1;
				if(m.get(i, j) != n)
					err += 1;
			}
		}

		if(err != 0) {
			"\nERROR: got <<toString(err)>> bad values on ";
			"2D test\n ";
			return(nil);
		}

		return(true);
	}

	// Test with a non-square matrix.
	testAsymmetric() {
		local err, i, j, n, m, sx, sy;

		sx = 7;
		sy = 5;

		m = new Matrix2D(sx, sy);
		n = 0;

		for(j = 1; j <= sy; j++) {
			for(i = 1; i <= sx; i++) {
				n += 1;
				m.set(i, j, n);
			}
		}

		err = 0;
		n = 0;
		for(j = 1; j <= sy; j++) {
			for(i = 1; i <= sx; i++) {
				n += 1;
				if(m.get(i, j) != n)
					err += 1;
			}
		}

		if(err != 0) {
			"\nERROR: got <<toString(err)>> bad values on ";
			"assymetric matrix test\n ";
			return(nil);
		}

		return(true);
	}

	// Test querying out-of-range values.  Should always return nil
	// and not throw any exceptions, crash the terp, or anything like
	// that.
	testOOB() {
		local err, i, j, n, m, sx, sy;

		sx = 7;
		sy = 5;

		m = new Matrix2D(sx, sy);
		n = 0;

		for(j = 1; j <= sy; j++) {
			for(i = 1; i <= sx; i++) {
				n += 1;
				m.set(i, j, n);
			}
		}

		err = 0;
		n = 0;
		for(j = sy + 1; j <= sy + 10; j++) {
			for(i = sx + 1; i <= sx + 10; i++) {
				n += 1;
				if(m.get(i, j) != nil)
					err += 1;
			}
		}

		if(err != 0) {
			"\nERROR: got <<toString(err)>> bad values on ";
			"out-of-bounds query test\n ";
			return(nil);
		}

		return(true);
	}

	testTranspose() {
		local m, n, t;

		m = new Matrix2D([
			[ 1, 2 ],
			[ 3, 4 ],
			[ 5, 6 ]
		]);
		n = new Matrix2D(m.transpose());

		t = new Matrix2D([
			[ 1, 3, 5 ],
			[ 2, 4, 6 ]
		]);

		if(!n.equals(t)) {
			"\nERROR: transpose test failed\n ";
			return(nil);
		}
		if(!new Matrix2D(n.transpose()).equals(m)) {
			"\nERROR: double transpose test failed\n ";
			return(nil);
		}
		n.set(1, 1, 10);
		if(n.equals(t)) {
			"\nERROR: equals() returned true on non-equal matrices\n ";
			return(nil);
		}

		return(true);
	}
;
