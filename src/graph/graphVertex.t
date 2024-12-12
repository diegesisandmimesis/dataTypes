#charset "us-ascii"
//
// graph.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataStructures.h"

class Vertex: object
	vertexID = nil

	_edgeTable = perInstance(new LookupTable)

	construct(id) { vertexID = id; }

	addEdge(v, e) {
		if(!isVertex(v) || !isEdge(e)) return(nil);
		if(_edgeTable[v.vertexID] != nil) return(nil);
		_edgeTable[v.vertexID] = e;
		return(true);
	}

	removeEdge(v) {
		local e;

		if(!isVertex(v)) return(nil);
		if((e = _edgeTable.removeElement(v.vertexID)) == nil)
			return(nil);
		e.clear();
		return(true);
	}

	removeEdges() {
	}
;
