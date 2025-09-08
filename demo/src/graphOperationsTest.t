#charset "us-ascii"
//
// graphOperationsTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the Graph class.
//
// It can be compiled via the included makefile with
//
//	# t3make -f graphOperationsTest.t3m
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
		local err, t;

		err = 0;
		t = 0;

		t += 1;
		if(!g0.clone().equals(g0)) {
			"ERROR: clone() failed\n ";
			err += 1;
		}

		t += 1;
		if(!g0.union(g1).equals(gUnion)) {
			"ERROR: union test failed\n ";
			err += 1;
		}

		t += 1;
		if(!g0.difference(g1).equals(gDiff)) {
			"ERROR: difference test failed\n ";
			err += 1;
		}

		t += 1;
		if(!g0.intersection(g1).equals(gInt)) {
			"ERROR: intersection test failed\n ";
			err += 1;
		}

		t += 1;
		if(!gSub.isSubgraphOf(g0)) {
			"ERROR: subgraph test 1 failed\n ";
			err += 1;
		}

		t+= 1;
		if(g0.isSubgraphOf(gSub)) {
			"ERROR: subgraph test 2 failed\n ";
			err += 1;
		}

		t += 1;
		if(!gDiff.disjoint(gInt)) {
			"ERROR: disjoint test 1 failed\n ";
			err += 1;
		}

		if(gDiff.disjoint(g0)) {
			"ERROR: disjoint test 2 failed\n ";
			err += 1;
		}

		if(err == 0) {
			"\npassed all tests (<<toString(t)>>)\n ";
		} else {
			"\nFAILED <<toString(err)>> of <<toString(t)>>
				tests\n ";
		}
	}
;

g0: Graph
	[ '1', '2', '3', '4', '5' ]
	[
		0,	1,	0,	0,	0,
		1,	0,	1,	1,	0,
		0,	1,	0,	0,	1,
		0,	1,	0,	0,	1,
		0,	0,	1,	1,	0
	]
;

g1: Graph
	[ '3', '4', '5', '6' ]
	[
		0,	1,	1,	0,
		1,	0,	0,	1,
		1,	0,	0,	1,
		0,	1,	1,	0
	]
;

gUnion: Graph
	[ '1', '2', '3', '4', '5', '6' ]
	[
		0,	1,	0,	0,	0,	0,
		1,	0,	1,	1,	0,	0,
		0,	1,	0,	1,	1,	0,
		0,	1,	1,	0,	1,	1,
		0,	0,	1,	1,	0,	1,
		0,	0,	0,	1,	1,	0
	]
;

gDiff: Graph
	[ '1', '2' ]
	[
		0,	1,
		1,	0
	]
;

gInt: Graph
	[ '3', '4', '5' ]
	[
		0,	0,	1,
		0,	0,	0,
		1,	0,	0
	]
;

gSub: Graph
	[ '2', '3', '4', '5' ]
	[
		0, 	1,	1,	0,
		1,	0,	0,	1,
		1,	0,	0,	1,
		0,	1,	1,	0
	]
;
