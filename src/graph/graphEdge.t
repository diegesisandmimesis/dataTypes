#charset "us-ascii"
//
// graph.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataStructures.h"

class Edge: object
	vertex0 = nil
	vertex1 = nil

	length = nil
	_defaultLength = 1

	_directed = nil

	construct(v0, v1, l?, d?) {
		if(!isVertex(v0) || !isVertex(v1)) return;
		vertex0 = v0;
		vertex1 = v1;
		length = ((l != nil) ? l : _defaultLength);

		if(d == true) _directed = true;
		if(self.ofKind(DirectedEdge)) _directed = true;

		initializeVertices();
	}

	clear() {
		vertex0 = nil;
		vertex1 = nil;
	}

	initializeVertices() {
		vertex0.addEdge(vertex1, self);
		if(!_directed)
			vertex1.addEdge(vertex0, self);
	}

	initializeEdge() {
		if(location == nil) return;
		if(location.ofKind(Vertex)) {
			if((location.location == nil)
				|| !location.location.ofKind(Graph))
				return;
			if(location.location.ofKind(DirectedGraph))
				_directed = true;
			vertex0 = location;
		}
		initializeVertices();
	}
;
