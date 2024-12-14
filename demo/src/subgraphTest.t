#charset "us-ascii"
//
// subgraphTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the finiteStateMachine
// library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f subgraphTest.t3m
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
		g.addVertex('foo1');
		g.addVertex('foo2');
		g.addVertex('bar1');
		g.addVertex('bar2');
		g.addVertex('baz1');
		g.addVertex('baz2');
		g.addVertex('baz3');

		g.addEdge('foo1', 'foo2');

		g.addEdge('bar1', 'bar2');

		g.addEdge('baz1', 'baz2');
		g.addEdge('baz1', 'baz3');
		g.addEdge('baz2', 'baz3');
		//g.addEdge('quux', 'foo');

		g.log();

		local l = g.generateSubgraphs();
		"There are <<toString(l.length)>> subgraphs:\n ";
		l.forEach(function(s) {
			"\n\t ";
			s.forEach(function(v) {
				"<<v.vertexID>> ";
			});
		});
		"\n ";
	}
;
