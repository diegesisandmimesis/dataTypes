#charset "us-ascii"
//
// tupleTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the finiteStateMachine
// library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f tupleTest.t3m
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
	totalTests = 0		// total number of tests run
	testFailures = 0	// number of tests that failed

	// Tests.
	// Structure is an array of arrays.  Each "outer" array is a test,
	// each test is two tuples, what firstTuple.matchTuple(secondTuple)
	// should return, and what firstTuple.exactMatchTuple(secondTuple)
	// should return.
	tests = static [
		[ tuple0, tuple1, true, true ],
		[ tuple1, tuple0, true, true ],
		[ tuple1, tuple2, true, nil ],
		[ tuple2, tuple1, nil, nil ],
		[ tuple3, tuple4, true, true ],
		[ tuple4, tuple3, true, true ],
		[ tuple4, tuple5, nil, nil ],
		[ tuple4, tuple6, nil, nil ],
		[ tuple4, tuple7, nil, nil ],
		[ tuple4, tuple8, nil, nil ],
		[ tuple4, tuple9, nil, nil ],
		[ tuple4, tuple10, nil, nil ]
	]

	newGame() {
		tests.forEach(function(o) {
			compareTuples(o[1], o[2], o[3], o[4]);
		});

		if(testFailures == 0) {
			"\nPassed all tests (<<toString(totalTests)>>)\n ";
		} else {
			"\nFAILED <<toString(testFailures)>> of
				<<toString(totalTests)>> tests\n ";
		}
	}

	// Args are:  two tuples, value of match, value of exact match
	compareTuples(t0, t1, v0, v1) {
		totalTests += 1;
		if((t0.matchTuple(t1) != v0)
			|| (t0.exactMatchTuple(t1) != v1)) {
			testFailures += 1;
			return(nil);
		}

		return(true);
	}
;

voidRoom: Room 'Void' "This is a featureless void. ";
otherRoom: Room 'Other Room' "This is the other room. ";
pebble: Thing 'small round pebble' 'pebble' "A small, round pebble. ";
rock: Thing 'ordinary rock' 'rock' "An ordinary rock. ";
alice: Person 'Alice' 'Alice'
	"She looks like the first person you'd turn to in a problem. "
	isProperName = true
	isHer = true
;
bob: Person 'Bob' 'Bob'
	"He looks like Robert, only shorter. "
	isProperName = true
	isHim = true
;

// Two identical tuples with just one property defined.
tuple0: Tuple srcObject = pebble;
tuple1: Tuple srcObject = pebble;

// A tuple with two properties defined.
// Because matchTuple() treats an undefined property as "match any",
// tuple1.matchTuple(tuple2) should pass (because tuple1 matches any
// tuple with pebble as the srcObject and it doesn't care about
// anything else), but tuple1.exactMatchTuple(tuple2) should fail (because
// they're not identical).  Also, tuple2.matchTuple(tuple1) should fail
// (because tuple2 cares about the dstObject property, and tuple1 doesn't
// have one).
tuple2: Tuple srcObject = pebble dstObject = rock;

// Two identical actions.  These define all possible properties.
tuple3: Tuple srcObject = pebble srcActor = alice
	dstObject = rock dstActor = bob room = voidRoom action = ThrowAtAction;
tuple4: Tuple srcObject = pebble srcActor = alice
	dstObject = rock dstActor = bob room = voidRoom action = ThrowAtAction;

// Now a bunch of tuples that vary from tuple3 and tuple4 by a single
// property.
tuple5: Tuple srcObject = rock srcActor = alice
	dstObject = rock dstActor = bob room = voidRoom action = ThrowAtAction;
tuple6: Tuple srcObject = pebble srcActor = bob
	dstObject = rock dstActor = bob room = voidRoom action = ThrowAtAction;
tuple7: Tuple srcObject = pebble srcActor = alice
	dstObject = pebble dstActor = bob
	room = voidRoom action = ThrowAtAction;
tuple8: Tuple srcObject = pebble srcActor = alice
	dstObject = rock dstActor = alice
	room = voidRoom action = ThrowAtAction;
tuple9: Tuple srcObject = pebble srcActor = alice
	dstObject = rock dstActor = bob room = otherRoom action = ThrowAtAction;
tuple10: Tuple srcObject = pebble srcActor = alice
	dstObject = rock dstActor = bob
	room = voidRoom action = AttackWithAction;
