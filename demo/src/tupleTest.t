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

#include "dataStructures.h"

versionInfo: GameID;
gameMain: GameMainDef
	newGame() {
		"tuple0 = tuple1:  <<toString(tuple0.matchTuple(tuple1))>>\n ";
	}
;

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

tuple0: Tuple srcObject = pebble;
tuple1: Tuple srcObject = pebble;
