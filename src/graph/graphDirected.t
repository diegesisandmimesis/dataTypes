#charset "us-ascii"
//
// graphDirected.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataStructures.h"

class DirectedGraph: Graph
	edgeClass = DirectedEdge

	addEdge(id0, id1, obj?) {
		local v0, v1;

		if((id0 == nil) || (id1 == nil)) return(nil);
		if((v0 = canonicalizeVertex(id0)) == nil) return(nil);
		if((v1 = canonicalizeVertex(id1)) == nil) return(nil);

		if(!isEdge(obj))
			obj = edgeClass.createInstance(v0, v1);

		v0.addEdge(v1, obj);

		return(obj);
	}

	removeEdge(id0, id1) {
		local v0, v1;

		if((id0 == nil) || (id1 == nil)) return(nil);
		if((v0 = canonicalizeVertex(id0)) == nil) return(nil);
		if((v1 = canonicalizeVertex(id1)) == nil) return(nil);
		v0.removeEdge(v1);

		return(true);
	}
;

class DirectedEdge: Edge
	initializeVertices() {
		vertex0.addEdge(vertex1, self);
	}
;
