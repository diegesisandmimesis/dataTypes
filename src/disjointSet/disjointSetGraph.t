#charset "us-ascii"
//
// disjointSetGraph.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

modify DisjointSetForest
	// Configure this forest based on the contents of the given graph.
	graphToForest(g) {
		// Make sure it's a graph.
		if(!isGraph(g))
			return(nil);

		// We only work on undirected graphs.
		if(g.directed)
			return(nil);

		// First, create a new disjoint-set instance for each vertex.
		g.forEachVertex({ v: makeSet(v.vertexID) });

		// Now join each disjoint set connected by an edge in the
		// graph.
		g.forEachEdge(function(e) {
			union(e.vertex0.vertexID, e.vertex1.vertexID);
		});

		return(true);
	}

	// Implementation of Kruskal's algorith,
	// Returns a new graph instance containg a minimum spanning tree
	// of the graph given in the first argument.
	// Second argument is an optional function used to sort the edges.
	// If given, function should accept two Edge instances as arguments.
	kruskal(g, fn?) {
		local i, l, r, v0, v1;

		if(!isGraph(g))
			return(nil);

		// Create the graph to hold our solution.
		r = new Graph();

		// Go through all the vertices, adding them to the new
		// graph and adding them as isolated disjoint-set objects
		// to this forest.
		g.forEachVertex(function(v) {
			makeSet(v.vertexID);
			r.addVertex(v.vertexID);
		});

		// Get a list of all the edges in the graph.
		l = g.getEdges();

		// If we have a sort function, use it.  Otherwise we
		// sort by edge length.
		if(isFunction(fn)) {
			l = l.sort(nil, { a, b: (fn)(a, b) });
		} else {
			l = l.sort(nil,
				{ a, b: a.getLength() - b.getLength() });
		}

		// Go through our sorted edge list.
		for(i = 1; i <= l.length; i++) {
			v0 = l[i].vertex0.vertexID;
			v1 = l[i].vertex1.vertexID;

			// Check to see if the vertices are in the same
			// disjoint-set.  If they aren't, add an edge
			// in the results graph and join their disjoint-sets.
			if(find(v0) != find(v1)) {
				r.addEdge(v0, v1);
				union(v0, v1);
			}
		}

		return(r);
	}
;
