#charset "us-ascii"
//
// markovTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the finiteStateMachine
// library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f markovTest.t3m
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
	tests = 0
	failures = 0
	results = perInstance(new Vector())

	newGame() {
		local i;

		for(i = 0; i < 10; i++) {
			aioSay('\n<<toString(chain0.getStateID())>>\n ');
			aioSay('\n<<toString(chain0.pickTransition())>>\n ');
		}
	}
;

chain0: MarkovChain
	[	'foo',	'bar',	'baz'	]
	[
		0,	0.75,	0.25,
		0.67,	0,	0.33,
		0.5,	0.5,	0
	]
	[	0.34,	0.34,	0.32	]
;
