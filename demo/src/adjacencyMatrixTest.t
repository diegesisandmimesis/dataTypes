#charset "us-ascii"
//
// adjacencyMatrixTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// It can be compiled via the included makefile with
//
//	# t3make -f adjacencyMatrixTest.t3m
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
		local r;

		r = graph1.adjacencyMatrix();
		r.log();
	}
;
graph1: Graph
	[ 'foo', 'bar', 'baz' ]
	[
		0,	1, 	1,
		1,	0,	1,
		1,	1,	0
	]
;
