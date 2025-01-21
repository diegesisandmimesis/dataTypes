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

#include "dataTypes.h"

versionInfo: GameID;
gameMain: GameMainDef
	tests = 0				// total number of tests
	failures = 0				// number of tests failed
	results = perInstance(new Vector())	// results of each test

	// Tests.
	// Each line is a test.  First two args are vertices, last is
	// whether or not the edge between them should exist.
	_tests = static [
		[ 'foo', 'bar', true ],
		[ 'bar', 'foo', true ],
		[ 'foo', 'baz', true ],
		[ 'baz', 'foo', true ],
		[ 'bar', 'baz', true ],
		[ 'baz', 'bar', true ]
	]

	newGame() {
		local i;

		// We're just testing a couple of different ways to declare
		// a graph, and we're verifying that all of them produce
		// the same graph.
		_runTests(graph0);
		_runTests(graph1);
		_runTests(graph2);

		_runTests(graph3);

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

	_runTests(g) {
		_tests.forEach(function(o) {
			_runTest(g, o[1], o[2], o[3]);
		});
	}

	_runTest(g, v0, v1, t) {
		tests += 1;
		results.append(isEdge(g.getEdge(v0, v1)) == t);
		if(results[results.length()] != true) failures += 1;
	}
;

// "Long form" graph declaration.
graph0: DirectedGraph;
+foo: Vertex 'foo';
++Edge ->bar;
++Edge ->baz;
+bar: Vertex 'bar';
++Edge ->foo;
++Edge ->baz;
+baz: Vertex 'baz';
++Edge ->foo;
++Edge ->bar;

// Same as above, using IDs instead of obj references in edge declarations
graph3: DirectedGraph;
+Vertex 'foo';
++Edge 'bar';
++Edge 'baz';
+Vertex 'bar';
++Edge 'foo';
++Edge 'baz';
+Vertex 'baz';
++Edge 'foo';
++Edge 'bar';

// "Short form" graph declaration
graph1: Graph
	[	'foo',	'bar',	'baz' ]
	[
		0,	1,	1,
		1,	0,	1,
		1,	1,	0
	]
;

// Declaration using the macro
DeclareGraph(graph2, [ 'foo', 'bar', 'baz' ],
	[
		0,	1,	1,
		1,	0,	1,
		1,	1,	0
	])
;
