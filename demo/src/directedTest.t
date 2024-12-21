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

		// Create a directed graph with two vertices
		g = new DirectedGraph();
		g.addVertex('foo');
		g.addVertex('bar');

		// Create foo -> bar.  This should NOT create bar -> foo.
		g.addEdge('foo', 'bar');

		// Make sure we got foo -> bar
		if(!isEdge(g.getEdge('foo', 'bar'))) {
			"FAILURE:  failed to create initial edge\n ";
			return;
		}

		// Make sure we DIDN'T get bar -> foo
		if(isEdge(g.getEdge('bar', 'foo'))) {
			"FAILURE:  created undirected graph\n ";
			return;
		}

		// Create bar -> foo
		g.addEdge('bar', 'foo');

		// Make sure we got the new edge
		if(!isEdge(g.getEdge('bar', 'foo'))) {
			"FAILURE:  failed to add edge\n ";
			return;
		}

		// Remove foo -> bar
		g.removeEdge('foo', 'bar');

		// Make sure the edge was removed
		if(isEdge(g.getEdge('foo', 'bar'))) {
			"FAILURE:  failed to remove edge\n ";
			return;
		}

		// Make sure we didn't ALSO remove bar -> foo
		if(!isEdge(g.getEdge('bar', 'foo'))) {
			"FAILURE:  removed extra edge\n ";
			return;
		}

		// We're done, hurray
		"Passed all tests\n ";
	}
;
