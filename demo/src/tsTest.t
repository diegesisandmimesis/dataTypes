#charset "us-ascii"
//
// tsTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// Simple test of the basic functionality of the TS class.
//
// Creates a timestamp, does some busywork, then reports the interval.
//
// It can be compiled via the included makefile with
//
//	# t3make -f tsTest.t3m
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
		local i, ts;

		ts = new TS();

		// Some busywork to add some time to the clock.
		for(i = 0; i < 10000; i++) {
			foozle();
			t3RunGC();
		}

		"\nThis dumb demo took <<toString(ts.getInterval())>> seconds ";
		"to run.\n ";
	}

	foozle() {
		local obj;

		obj = new Thing();
		if(obj) {}
	}
;
