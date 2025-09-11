#charset "us-ascii"
//
// disjointSetGraph.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

modify DisjointSetForest
	graphToForest(g) {
		if(!isGraph(g))
			return(nil);

		// We only work on undirected graphs.
		if(g.directed)
			return(nil);

		g.forEachVertex({ v: makeSet(v.vertexID) });
		g.forEachEdge(function(e) {
			union(e.vertex0.vertexID,
				e.vertex1.vertexID);
		});

		return(true);
	}

	kruskal(g) {
		local r;

		if(!isGraph(g))
			return(nil);

		r = new Graph();

		g.forEachVertex(function(v) {
			makeSet(v.vertexID);
			r.addVertex(v.vertexID);
		});
		g.forEachEdge(function(e) {
			if(find(e.vertex0.vertexID)
				== find(e.vertex1.vertexID))
				return;
			r.addEdge(e.vertex0.vertexID,
				e.vertex1.vertexID);
			union(e.vertex0.vertexID,
				e.vertex1.vertexID);
		});

		return(r);
	}
;
