#charset "us-ascii"
//
// canvasTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the finiteStateMachine
// library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f canvasTest.t3m
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
		local c;

		c = new AsciiCanvas(10, 10);

		"\nEmpty canvas:\n ";
		c.log();
		c.fill(nil);

		"\n<.p>A boy and his dog:\n ";
		c.setXY(1, 1, '@');
		c.setXY(2, 2, 'd');
		c.log();
		c.fill(nil);

		"\n<.p>Diagonal line:\n ";
		c.line(9, 0, 0, 9, '#');
		c.log();
		c.fill(nil);

		"\n<.p>Line with opposite slope:\n ";
		c.line(0, 0, 9, 9, '#');
		c.log();
		c.fill(nil);

		"\n<.p>Vertical line:\n ";
		c.line(4, 0, 4, 9, '#');
		c.log();
		c.fill(nil);

		"\n<.p>Horizontal line:\n ";
		c.line(0, 4, 9, 4, '#');
		c.log();
	}
;
