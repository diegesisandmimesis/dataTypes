#charset "us-ascii"
//
// splineTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// Simple test of the basic functionality of the Matrix class.
//
// Creates a couple of matrices, inserts values and then queries them.
//
// It can be compiled via the included makefile with
//
//	# t3make -f splineTest.t3m
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
	iterations = 5000
	ts = nil
	newGame() {
		local i;

		/*
		if(splineTest()) {
			"\npassed all tests\n ";
		} else {
			"\nERROR: failed one or more tests\n ";
		}
		*/
		ts = new TSProf();
		i = 0;
		while(i < 10) {
			splineTest2();
			splineTest();
			i++;
		}

		ts.report();
	}

	_randomXY() { return(new _XY(randomInt(-10, 10), randomInt(-10, 10))); }

	splineTest() {
		ts.start('1');
		_splineTest();
		ts.stop('1');
	}
	_splineTest() {
		local i, spl;

		i = 0;
		while(i < iterations) {
			spl = new BarSpline(_randomXY(), _randomXY(),
				_randomXY);
			spl.initSpline();
			i++;
		}
	}
	splineTest2() {
		ts.start('2');
		_splineTest2();
		ts.stop('2');
	}
	_splineTest2() {
		local i, spl;

		i = 0;
		while(i < iterations) {
			spl = new FooSpline(_randomXY(), _randomXY(),
				_randomXY);
			spl.initSpline();
			i++;
		}
	}
;

class FooSpline: BezierSpline
	_initSplinePoints(a1) {
		local i, n, n2, t0, t1;
		local v0, v1, v2;

		_points = new Vector(segments + 1);

		n = segments;
		n2 = n * n;

		for(i = 0; i <= n; i++) {
			t1 = i;
			t0 = n - i;

			v0 = t0 * t0;
			v1 = 2 * t0 * t1;
			v2 = t1 * t1;

			_points.append(xyClass.createInstance(
				(((v0 * p0.x) + (v1 * a1.x)
					+ (v2 * p2.x)) * scale) / n2,
				(((v0 * p0.y) + (v1 * a1.y)
					+ (v2 * p2.y)) * scale) / n2
			));
		}
	}
;

class BarSpline: BezierSpline
	_initSplinePoints(a1) {
		local i, n, n2, t0, t1;

		_points = new Vector(segments + 1);

		n = segments;
		n2 = n * n;

		for(i = 0; i <= n; i++) {
			t1 = i;
			t0 = n - i;

			_points.append(xyClass.createInstance(
				(((t0 * t0 * p0.x) + (2 * t0 * t1 * a1.x)
					+ (t1 * t1 * p2.x)) * scale) / n2,
				(((t0 * t0 * p0.y) + (2 * t0 * t1 * a1.y)
					+ (t1 * t1 * p2.y)) * scale) / n2
			));
		}
	}
;
