#charset "us-ascii"
//
// graphInitTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the finiteStateMachine
// library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f graphInitTest.t3m
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
		myGraph.log();
		matrixGraph.log();
		g2.log();
	}
;

myGraph: DirectedGraph;
+foo: Vertex 'foo';
++Edge ->bar;
++Edge ->baz;
+bar: Vertex 'bar';
++Edge ->foo;
++Edge ->baz;
+baz: Vertex 'baz';
++Edge ->foo;
++Edge ->bar;

matrixGraph: Graph
	@[	'foo',	'bar',	'baz' ]
	@[
		0,	1,	1,
		1,	0,	1,
		1,	1,	0
	]
;

DeclareGraph(g2, [ 'foo', 'bar', 'baz' ],
	[
		0,	1,	1,
		1,	0,	1,
		1,	1,	0
	])
;
