#charset "us-ascii"
//
// directedTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the finiteStateMachine
// library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f directedTest.t3m
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
		local g;

		g = new DirectedGraph();
		g.addVertex('foo');
		g.addVertex('bar');
		g.addEdge('foo', 'bar');
		g.log();

		g.addEdge('bar', 'foo');
		g.log();

		g.removeEdge('foo', 'bar');
		g.log();
	}
;
