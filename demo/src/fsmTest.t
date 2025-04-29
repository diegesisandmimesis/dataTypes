#charset "us-ascii"
//
// fsmTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the finiteStateMachine
// class.
//
// It can be compiled via the included makefile with
//
//	# t3make -f fsmTest.t3m
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
		// Trivial test to verify the FSM declaration macro,
		// FSM initialization, and the existence of the FSM ID
		// function.
		if(foozleID() != 'foo') {
			"FAILURE:  failed to init FSM\n ";
		} else {
			"Passed all tests\n ";
		}
	}
;

DefineFSM(foozle, [ 'foo', 'bar', 'baz' ]);
