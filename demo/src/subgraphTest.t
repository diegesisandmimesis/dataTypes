#charset "us-ascii"
//
// subgraphTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the subgraph identification
// logic.
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

#include "dataTypes.h"

versionInfo: GameID;
gameMain: GameMainDef
	// Answer key for our subgraph problem.
	subgraphs = static [
		[ 'foo1', 'foo2' ],
		[ 'bar1', 'bar2' ],
		[ 'baz1', 'baz2', 'baz3' ]
	]

	newGame() {
		local i, l, r0, r1, t;

		// Generate the subgraphs
		l = graph1.generateSubgraphs();

		// We know (because we designed the problem that way)
		// that there should be three subgroups.  Fail if
		// that's not what we got.
		if(l.length != 3) {
			"ERROR:  got wrong number of subgraphs (got
				<<toString(l.length)>>, needed 3)\n ";
			return;
		}

		// Make a sorted version of the answer key defined
		// above.  We do it this way (instead of hardcoding it)
		// in case there are any interpreter-specific pecularities
		// about stringification of arrays and so on.
		// We sort each sub-array, and then sort the result array
		// to get a canonical ordering for both the subgraphs
		// and the vertices inside each subgraph.
		r0 = new Vector();
		subgraphs.forEach({ x: r0.append(toString(x.sort())) });
		r0.sort();

		// Now we canonicalize the computed subgraphs the same
		// way we did above.
		r1 = new Vector();	// result array
		t = new Vector();	// tmp array for building subgraph
		l.forEach(function(s) {
			// Reset the temp array
			t.setLength(0);
			// Populate the temp array with the vertex IDs
			s.forEach({ x: t.append(x.vertexID) });
			// Sort the vertex IDs and add it to our result array.
			r1.append(toString(t.sort()));
		});

		// Sort the result array
		r1.sort();

		// Our canonicalize result array and canonicalized
		// answer key should be the same.
		for(i = 1; i <= r0.length; i++) {
			if(r0[i] != r1[i]) {
				"ERROR:  bad subgroup\n ";
				return;
			}
		}

		"All tests passed\n ";
	}
;

// Graph declaration.  There are three subgraphs.
// This is
//	foo1 <-> foo2
//	bar1 <-> bar2
//	baz1 <-> baz2 <-> baz3 [ <-> baz1 ] (complete subgraph)
DeclareGraph(graph1, [ 'foo1', 'foo2', 'bar1', 'bar2', 'baz1', 'baz2', 'baz3' ],
[
	0, 1, 0, 0, 0, 0, 0,
	1, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 1, 0, 0, 0,
	0, 0, 1, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 1, 1,
	0, 0, 0, 0, 1, 0, 1,
	0, 0, 0, 0, 1, 1, 0
])
;
