#charset "us-ascii"
//
// disjointSetKruskal.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the disjointSet library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f disjointSetKruskal.t3m
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
		local f, g, i, p;

		f = DisjointSetForest.createInstance();
		for(i = 0; i <= 8; i++)
			f.makeSet(toString(i));

		f.union('1', '4');
		f.union('1', '5');
		f.union('4', '8');
		f.union('5', '8');
		f.union('2', '3');
		f.union('2', '7');
		f.union('2', '0');

		g = g0.union(g1).union(g2);
		f = DisjointSetForest.createInstance();

		g.addEdge('6', '8');
		g.addEdge('0', '6');

		g = f.kruskal(g, function(a, b) {
			local v0, v1;
			v0 = toInteger(a.vertex0.vertexID)
				+ toInteger(a.vertex1.vertexID);
			v1 = toInteger(b.vertex0.vertexID)
				+ toInteger(b.vertex1.vertexID);
			return(v0 - v1);
		});

		if(!isGraph(g)) {
			"\nERROR: Kruskal algorithm failed\n ";
			return;
		}
		if((p = g.getDijkstraPath('1', '6')) == nil) {
			"\nERROR: pathfinding failed\n ";
			return;
		}

		"\npath = <<toString(p)>>\n ";
	}
;

g0: Graph
	[ '1', '4', '5', '8' ]
	[
		0,	1,	1,	0,
		1,	0,	0,	1,
		1,	0,	0,	1,
		0,	1,	1,	0
	]
;

g1: Graph
	[ '2', '3', '7', '0' ]
	[
		0,	1,	1,	1,
		1,	0,	0,	0,
		1,	0,	0,	0,
		1,	0,	0,	0
	]
;

g2: Graph;
+Vertex '6';
