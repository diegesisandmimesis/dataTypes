#charset "us-ascii"
//
// agrippaSquareTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// Simple test of the basic functionality of the Matrix class.
//
// Creates a couple of matrices, inserts values and then queries them.
//
// It can be compiled via the included makefile with
//
//	# t3make -f agrippaSquareTest.t3m
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
		local i, sq;

		i = 1;
		for(i = 3; i <= 9; i++) {
			sq = new AgrippaSquare(i);
			sq.log();
			"\nvalidate = <<toString(sq.validate())>>\n ";
		}
	}
;
