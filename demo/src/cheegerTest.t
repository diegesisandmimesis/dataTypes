#charset "us-ascii"
//
// cheegerTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the finiteStateMachine
// library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f cheegerTest.t3m
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
		local foo, i, n, v;

		n = 8;
		v = new Vector(n);
		for(i = 0; i < n; i++) {
			v.append('foo' + toString(i));
		}
		foo = permutations(v);
		"\nPermutations:\n ";
		foo.forEach(function(o) {
			"\n\t<<toString(o)>>\n ";
		});
/*
		local g;

		g = new Graph();
		g.addVertex('foo1');
		g.addVertex('foo2');
		g.addVertex('foo3');
		g.addVertex('foo4');
		g.addVertex('foo5');
		g.addVertex('foo6');

		g.addEdge('foo1', 'foo2');
		g.addEdge('foo2', 'foo3');
		g.addEdge('foo3', 'foo4');
		g.addEdge('foo4', 'foo5');
		g.addEdge('foo5', 'foo6');
		g.addEdge('foo6', 'foo1');

		"Cheeger constant = <<toString(g.getCheegerConstant())>>\n ";

		g.addEdge('foo1', 'foo3');
		g.addEdge('foo1', 'foo4');
		g.addEdge('foo1', 'foo5');
		g.addEdge('foo1', 'foo6');

		g.addEdge('foo2', 'foo4');
		g.addEdge('foo2', 'foo5');
		g.addEdge('foo2', 'foo6');


		g.addEdge('foo3', 'foo5');
		g.addEdge('foo3', 'foo6');

		g.addEdge('foo4', 'foo6');

		"Cheeger constant = <<toString(g.getCheegerConstant())>>\n ";
*/
	}
;
