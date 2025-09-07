#charset "us-ascii"
//
// btTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// Test of the recursive backtracker.
//
// It can be compiled via the included makefile with
//
//	# t3make -f btTest.t3m
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
		// Generic test, which just makes sure there's an assignment
		// for each variable.
		if(!inherited(frm))
			return(nil);

		// Bob rejects vegetables starting with B.
		// The *indices* in the result vector as the same as the
		// indices in the variable vector (vList).  So result[2]
		// means "the value assigned to the second variable",
		// and in this case the second variable is Bob.
		// The *values* of the result vector are indices in
		// the value vector (pList).  So result[2] = 2 means
		// we're a) checking the value assigned to Bob (that's
		// the lefthand side), and b) if the value is the second
		// one in the value vector, in this case "broccoli".
		// So this rule means that we're rejecting a result only
		// if it involves givving broccoli to Bob.
		return(frm.result[2] != 2);
	}
;

versionInfo: GameID;
gameMain: GameMainDef
	veg = static [ 'asparagus', 'broccoli', 'carrots', 'daikon' ]
	people = static [ 'Alice', 'Bob', 'Carol' ]

	newGame() {
		local f;

		// Create the initial query:  list of variables to
		// assign, list of possible assignments, and progress so
		// far.
		f = new BTFrame(people, veg, nil);

		// Contine as long as we have another frame to process.
		while(f != nil) {
			// The return value of BT.run() is true if the
			// backtracker found a solution, nil otherwise.
			if(demoBacktracker.run(f) != nil) {
				// If the return value from .run() was
				// true, the solution it found will be
				// the top of the stack.  Here we lift
				// it off the stack.
				f = demoBacktracker.pop();

				// Print the contents of the frame.
				printFrame(f);

				// Pick the next frame in the sequence
				// and continue.
				f = demoBacktracker.next(f);
			}
		}
	}

	// Print a single stack frame.
	printFrame(f) {
		local ar, i;

		// Make an array containing the assignments.
		// Note that the result vector, here f.result,
		// contains the *indices*, in f.pList, of the
		// assignments, NOT the values themselves.
		ar = new Vector(f.result.length);
		for(i = 1; i <= f.result.length; i++)
			ar.append('<<f.vList[i]>> has
				<<f.pList[f.result[i]]>>');

		// Have the string lister format the array.
		"<<stringLister.makeSimpleList(ar)>>.\n ";
	}
;
