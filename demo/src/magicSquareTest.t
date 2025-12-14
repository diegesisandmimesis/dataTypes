#charset "us-ascii"
//
// magicSquareTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// Simple test of the basic functionality of the Matrix class.
//
// Creates a couple of matrices, inserts values and then queries them.
//
// It can be compiled via the included makefile with
//
//	# t3make -f magicSquareTest.t3m
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

		for(i = 3; i < 8; i++) {
			"\n===ORDER <<toString(i)>>===\n ";
			sq = new MagicSquare(i);
			sq.log();
			"\nvalidate = <<toString(sq.validate())>>\n ";
			"\n===ORDER <<toString(i)>>===\n ";
		}
	}
;
