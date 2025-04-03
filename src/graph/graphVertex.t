#charset "us-ascii"
//
// graph.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

class Vertex: object
	// Unique-ish ID for this vertex
	vertexID = nil

	// Graph we're a part of
	_graph = nil

	// Table to hold our edges
	_edgeTable = perInstance(new LookupTable)

	// Temporary flag used when computing path lengths.
	_dijkstraFlag = nil

	construct(id) { vertexID = id; }

	getGraph() { return(_graph); }
	setGraph(v) { if(isGraph(v)) _graph = v; }

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
		local e, l;

		l = _edgeTable.keysToList();
		l.forEach(function(id) {
			e = _edgeTable[id];
			_edgeTable.removeElement(id);
			e.clear();
		});
	}

	getEdge(v) {
		if(!isVertex(v)) return(nil);
		return(_edgeTable[v.vertexID]);
	}

	getEdges() { return(_edgeTable.valsToList()); }
	getEdgeIDs() { return(_edgeTable.keysToList()); }

	getDegree() { return(_edgeTable.keysToList().length); }
	isAdjacent(id) { return(_edgeTable[id] != nil); }

	initializeVertex() {
		if(!isGraph(location)) return;
		location.addVertex(self);
	}
;
