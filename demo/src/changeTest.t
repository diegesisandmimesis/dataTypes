#charset "us-ascii"
//
// changeTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the finiteStateMachine
// library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f changeTest.t3m
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
	tests = 0				// total test
	failures = 0				// number of failures
	results = perInstance(new Vector())	// results of each test

	// List of tests to run.
	// Each line is a test.  First element is the state to transition
	// to, second is the state the FSM should be in after the transition.
	// Mostly to check for cases where the FSM doesn't reject
	// state changes without declared transitions.
	_tests = static [
		[ nil, 'foo' ],		// test initial state
		[ 'bar', 'bar' ],	// foo -> bar is an edge, should pass
		[ 'baz', 'baz' ],	// bar -> baz is also an edge
		[ 'foo', 'baz' ],	// foo -> baz is not an edge,
					//	state should stay baz
		[ 'bar', 'baz' ]	// bar -> baz is an edge, but
					//	baz -> bar should not be one
	]

	newGame() {
		local i;

		_tests.forEach(function(o) {
			_test(o[1], o[2]);
		});
		if(failures == 0) {
			"Passed all tests (<<toString(tests)>>)\n ";
		} else {
			"FAILED <<toString(failures)>> of <<toString(tests)>>
				tests\n ";
			for(i = 1; i <= results.length; i++) {
				if(results[i] != true)
					"\n\tFAILED test <<toString(i)>>\n ";
			}
		}
	}

	_test(toID, id) {
		tests += 1;
		if(toID) foozleFSM.toState(toID);
		results.append(foozleID() == id);
		if(results[results.length()] != true)
			failures += 1;
	}
;

// State machine with three states and the following transitions:
// 	foo -> bar -> baz
DefineFSM(foozle, [ 'foo', 'bar', 'baz' ]);
+Transition 'foo' 'bar';
+Transition 'bar' 'baz';
