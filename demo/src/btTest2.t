#charset "us-ascii"
//
// btTest2.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// Test of the recursive backtracker.
//
// It can be compiled via the included makefile with
//
//	# t3make -f btTest2.t3m
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

// Backtracker instance.  This is where we implement our instance-specific
// logic.
demoBacktracker: BT
	accept(frm) {
		if(!inherited(frm))
			return(nil);
		return(true);
	}
;

versionInfo: GameID;
gameMain: GameMainDef
	veg = static [
		[ 'a1', 'a2', 'a3' ],
		[ 'b1', 'b2' ],
		[ 'c1', 'c2', 'c3', 'c4' ]
	]
	people = static [ 'Alice', 'Bob', 'Carol' ]

	newGame() {
		local f;

		f = new AC3BTFrame(people, veg, nil);

		while(f != nil) {
			if(demoBacktracker.run(f) != nil) {
				f = demoBacktracker.pop();
				printFrame(f);
				f = demoBacktracker.next(f);
			} else {
				f = nil;
			}
		}
	}

	printFrame(f) {
		local ar, i;

		ar = new Vector(f.result.length);
		for(i = 1; i <= f.result.length; i++)
			ar.append('<<f.vList[i]>> has
				<<f.pList[i][f.result[i]]>>');

		// Have the string lister format the array.
		"<<stringLister.makeSimpleList(ar)>>.\n ";
	}
;
