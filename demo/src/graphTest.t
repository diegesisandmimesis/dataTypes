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
	tests = 0
	failures = 0
	results = perInstance(new Vector())

	_tests = static [
		[ 'foo', 'bar', true ],
		[ 'bar', 'foo', true ],
		[ 'foo', 'baz', true ],
		[ 'baz', 'foo', true ],
		[ 'bar', 'baz', true ],
		[ 'baz', 'bar', true ]
	]

	newGame() {
		local g, i;

		// Declare a simple three vertex undirected complete graph.
		g = new Graph();
		g.addVertex('foo');
		g.addVertex('bar');
		g.addVertex('baz');
		g.addEdge('foo', 'bar');
		g.addEdge('foo', 'baz');
		g.addEdge('bar', 'baz');

		_runTests(g);
		g.removeEdge('foo', 'bar');

		_runTest(g, 'foo', 'bar', nil);
		_runTest(g, 'bar', 'foo', nil);

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

	_runTest(g, v0, v1, t) {
		tests += 1;
		results.append(isEdge(g.getEdge(v0, v1)) == t);
		if(results[results.length()] != true) failures += 1;
	}

	_runTests(g) {
		_tests.forEach(function(o) {
			_runTest(g, o[1], o[2], o[3]);
		});
	}
;
