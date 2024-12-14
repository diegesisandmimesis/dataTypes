#charset "us-ascii"
//
// graphTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the finiteStateMachine
// library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f graphTest.t3m
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

		g = new Graph();
		g.addVertex('foo');
		g.addVertex('bar');
		g.addVertex('baz');
		g.addEdge('foo', 'bar');
		g.addEdge('foo', 'baz');
		g.addEdge('bar', 'baz');
		g.removeEdge('foo', 'bar');
		g.log();
	}
;
