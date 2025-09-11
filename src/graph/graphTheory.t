#charset "us-ascii"
//
// graphTheory.t
//
//	Methods related to graph theory.  This is really vaguely defined
//	because graphs in general are related to graph theory.  In practical
//	terms the stuff that's here is here because it seems like most
//	game authors won't need it, even if they need Graph for something.
//
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

modify Graph
	// Returns a new Graph instance containing the union of this
	// graph and the argument graph.
	union(g) {
		local r;

		if(!isGraph(g))
			return(nil);

		r = clone();

		g.forEachVertex({ v: r.addVertex(v.vertexID) });
		g.forEachEdge({
			e: r.addEdge(e.vertex0.vertexID, e.vertex1.vertexID)
		});

		return(r);
	}

	// Returns a new Graph instance containing the difference of this
	// graph and the argument graph.
	difference(g) {
		local r;

		if(!isGraph(g))
			return(nil);

		r = clone();

		g.forEachVertex({ v: r.removeVertex(v.vertexID) });
		g.forEachEdge({
			e: r.removeEdge(e.vertex0.vertexID, e.vertex1.vertexID)
		});

		return(r);
	}

	// Returns a new Graph instance containing the intersection of this
	// graph and the argument graph.
	intersection(g) {
		local r;

		if(!isGraph(g))
			return(nil);

		r = clone();
		forEachVertex(function(v) {
			if(g.getVertex(v.vertexID))
				return;
			r.removeVertex(v.vertexID);
		});
		forEachEdge(function(e) {
			if(g.getEdge(e.vertex0.vertexID, e.vertex1.vertexID))
				return;
			r.removeEdge(e.vertex0.vertexID, e.vertex1.vertexID);
		});

		return(r);
	}

	// Returns boolean true if the argument graph is the same as this
	// graph.
	equals(g) {
		if(!isGraph(g))
			return(nil);

		return(adjacencyMatrix().equals(g.adjacencyMatrix()));
	}

	// Returns boolean true if the calling graph and argument graph
	// are disjoing.  That is, they contain no common vertices or edges.
	disjoint(g) {
		local r;

		if((r = intersection(g)) == nil) return(nil);
		return(r.getOrder() == 0);
	}

	isSubgraphOf(g) {
		local i, l;

		if(!isGraph(g))
			return(nil);

		l = getVertexIDs();
		for(i = 1; i <= l.length; i++)
			if(g.getVertex(l[i]) == nil) return(nil);

		l = getEdges();
		for(i = 1; i <= l.length; i++)
			if(g.getEdge(l[i].vertex0.vertexID,
				l[i].vertex1.vertexID) == nil)
					return(nil);

		return(true);

	}

	complement() {
		local r;

		if(ofKind(DirectedGraph))
			r = DirectedGraph.createInstance();
		else
			r = Graph.createInstance();

		forEachVertex({ v: r.addVertex(v.vertexID) });
		forEachVertex(function(v0) {
			forEachVertex(function(v1) {
				if(v0 == v1) return;
				if(getEdge(v0.vertexID, v1.vertexID) != nil)
					return;
				r.addEdge(v0.vertexID, v1.vertexID);
			});
		});

		return(r);
	}

	minimumDegree() {
		local d, r;

		r = nil;
		forEachVertex(function(v) {
			d = v.getDegree();
			if((r == nil) || (d < r))
				r = d;
		});

		return(r);
	}

	maximumDegree() {
		local d, r;

		r = nil;
		forEachVertex(function(v) {
			d = v.getDegree();
			if((r == nil) || (d > r))
				r = d;
		});

		return(r);
	}

	isRegular() {
		local d, i, l;

		d = nil;
		l = getVertices();
		for(i = 1; i <= l.length; i++) {
			if(d == nil)
				d = l[i].getDegree();
			if(d != l[i].getDegree())
				return(nil);
		}

		return(true);
	}
;
