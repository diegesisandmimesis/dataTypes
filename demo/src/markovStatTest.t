#charset "us-ascii"
//
// markovStatTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the finiteStateMachine
// library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f markovStatTest.t3m
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

#include "statTest.h"
#ifndef STAT_TEST_H
#error "This demo requires the statTest module."
#error "https://github.com/diegesisandmimesis/statTest"
#error "It should be in the same parent directory as this module.  So if"
#error "eventScheduler is in /home/user/tads/eventScheduler, then"
#error "statTest should be in /home/user/tads/statTest ."
#endif // STAT_TEST_H

versionInfo: GameID;
gameMain: GameMainDef
	newGame() {
		local t;

		t = new MarkovTest0();
		t.runTest();
		t.report();

		t = new MarkovTest1();
		t.runTest();
		t.report();

		"Tests complete\n ";
	}
;

// The rate of picking "foo" and "bar" when in "baz" should be
// roughly the same.
class MarkovTest0: StatTestRMS
	svc = 'MarkovTest0'
	outcomes = static [ 'foo', 'bar' ]
	pickOutcome() {
		chain0.setState('baz');
		return(chain0.pickTransition());
	}
;

// The rate of all three states should be the same when starting from "bar".
class MarkovTest1: StatTestRMS
	svc = 'MarkovTest1'
	outcomes = static [ 'foo', 'bar', 'baz' ]
	pickOutcome() {
		chain0.setState('bar');
		return(chain0.pickTransition());
	}
;

// Simple three-state chain.
chain0: MarkovChain
	[	'foo',	'bar',	'baz'	]	// list of states
	[
		0,	0.75,	0.25,	// chance of foo -> [ foo, bar, baz ]
		0.33,	0.33,	0.34,	// chance of bar -> [ foo, bar, baz ]
		0.5,	0.5,	0	// chance of baz -> [ foo, bar, baz ]
	]
	[	0.34,	0.34,	0.32	]	// chances for starting states
;
