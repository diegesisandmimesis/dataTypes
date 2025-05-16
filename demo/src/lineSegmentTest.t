#charset "us-ascii"
//
// lineSegmentTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// Simple test of the basic functionality of the Matrix class.
//
// Creates a couple of matrices, inserts values and then queries them.
//
// It can be compiled via the included makefile with
//
//	# t3make -f lineSegmentTest.t3m
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
		local l0, l1;

		l0 = new LineSegment(new XY(0, 0), new XY(1, 1));
		l1 = new LineSegment(new XY(0, 1), new XY(1, 0));

		"\nintersect = <<toString(l0.intersects(l1))>>\n ";
	}
;
