#charset "us-ascii"
//
// graph.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

class Edge: object
	vertex0 = nil
	vertex1 = nil

	_id0 = nil
	_id1 = nil

	_graph = nil

	length = nil
	_defaultLength = 1

	directed = nil

	construct(v0, v1, l?, d?) {
		if(!isVertex(v0) || !isVertex(v1)) return;
		vertex0 = v0;
		vertex1 = v1;
		length = ((l != nil) ? l : _defaultLength);

		if(d == true) directed = true;
		if(self.ofKind(DirectedEdge)) directed = true;

		initializeVertices();
	}

	clear() {
		vertex0 = nil;
		vertex1 = nil;
	}

	getLength() { return(length); }
	setLength(v) { length = v; }

	getGraph() {
		if(_graph == nil)
			if(isVertex(vertex0)) _graph = vertex0.getGraph();

		return(_graph);
	}

	initializeVertices() {
		local g;

		vertex0.addEdge(vertex1, self);
		if(!directed)
			vertex1.addEdge(vertex0, self);
		if((g = getGraph()) == nil) return;
		g.graphUpdated();
	}

	initializeEdge() {
		if(length == nil) length = _defaultLength;
		if(location == nil) return;
		if(location.ofKind(Graph)) {
			if(vertex0 == nil)
				if((vertex0 = location.getVertex(_id0)) == nil)
					return;
			if(vertex1 == nil)
				if((vertex1 = location.getVertex(_id1)) == nil)
					return;
		}
		if(location.ofKind(Vertex)) {
			if((location.location == nil)
				|| !location.location.ofKind(Graph))
				return;
			if(location.location.ofKind(DirectedGraph))
				directed = true;
			vertex0 = location;
			if(vertex1 == nil)
				if((vertex1 = location.location.getVertex(_id1))
					== nil)
					return;
		}
		initializeVertices();
	}

;
