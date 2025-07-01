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

	_labels = nil

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
		if(getGraph().directed != true)
			v.removeEdge(self);
		e.clear();
		return(true);
	}

	removeEdges() {
		local g, v;

		if((g = getGraph()) == nil) return(nil);
		_edgeTable.keysToList().forEach(function(id) {
			if((v = g.canonicalizeVertex(id)) == nil)
				return;
			removeEdge(v);
		});
		return(true);
/*
		local e, l;

		l = _edgeTable.keysToList();
		l.forEach(function(id) {
			e = _edgeTable[id];
			_edgeTable.removeElement(id);
			e.clear();
		});
*/
	}

	getEdge(v) {
		if(!isVertex(v)) return(nil);
		return(_edgeTable[v.vertexID]);
	}

	getEdges() { return(_edgeTable.valsToList()); }
	getEdgeIDs() { return(_edgeTable.keysToList()); }

	getAdjacentVertices() {
		local g, r;

		if((g = getGraph()) == nil) return([]);
		r = new Vector();
		getEdgeIDs.forEach(function(eid) {
			local v;
			if((v = g.canonicalizeVertex(eid)) == nil) return;
			r.appendUnique(v);
		});

		return(r.toList());
	}

	getDegree() { return(_edgeTable.keysToList().length); }
	isAdjacent(id) { return(_edgeTable[id] != nil); }

	initializeVertex() {
		if(!isGraph(location)) return;
		location.addVertex(vertexID, self);
	}

	label() {
		local g;

		if((g = getGraph()) == nil)
			return(nil);

		return(g.vertexLabel(self));
	}
;
