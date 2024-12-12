#charset "us-ascii"
//
// graph.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataStructures.h"

class Graph: object
	vertexClass = Vertex
	edgeClass = Edge

	_vertexTable = perInstance(new LookupTable)

	// Add a vertex to the graph.
	//	addVertex(foo);		If foo is a Vertex instance, add it
	//	addVertex('foo', foo);	Add Vertex instance foo with ID 'foo'
	//	addVertex('foo');	Create new Vertex instance, add it
	//				with ID 'foo'
	addVertex(id, obj?) {
		if(id == nil)
			return(nil);

		if(isVertex(id))
			obj = id;

		if(!isVertex(obj))
			obj = vertexClass.createInstance(id);

		_addVertex(obj);

		return(obj);
	}

	// Low-level method to insert a Vertex instance into our table.
	_addVertex(obj) {
		if(!isVertex(obj) || (obj.vertexID == nil)) return(nil);
		_vertexTable[obj.vertexID] = obj;
		return(true);
	}

	// Returns vertex with the given ID.
	getVertex(id) { return(_vertexTable[id]); }

	// Removes the given vertex from the table.
	removeVertex(id) {
		local v;

		// Make sure we got a valid Vertex or vertex ID.
		if((v = canonicalizeVertex(id)) == nil)
			return(nil);

		// Remove it from our table.
		if(!_vertexTable.removeElement(v.vertexID))
			return(nil);

		// Have it remove all its edges.  This will ping any
		// vertices this vertex is connected to.
		v.removeEdges();

		return(true);
	}

	// Given a vertex object or a valid vertex ID, return the matching
	// vertex object.
	// Used on Graph methods so they can take either an object or an
	// ID as an argument.
	canonicalizeVertex(v) {
		if(v == nil) return(nil);
		if(v.ofKind(vertexClass)) return(v);
		return(getVertex(v));
	}

	addEdge(id0, id1, obj?) {
		local v0, v1;

		if((id0 == nil) || (id1 == nil)) return(nil);
		if((v0 = canonicalizeVertex(id0)) == nil) return(nil);
		if((v1 = canonicalizeVertex(id1)) == nil) return(nil);
		if(!isEdge(obj))
			obj = edgeClass.createInstance(v0, v1);

		v0.addEdge(v1, obj);
		v1.addEdge(v0, obj);

		return(obj);
	}

	removeEdge(id0, id1) {
		local v0, v1;

		if((id0 == nil) || (id1 == nil)) return(nil);
		if((v0 = canonicalizeVertex(id0)) == nil) return(nil);
		if((v1 = canonicalizeVertex(id1)) == nil) return(nil);
		v0.removeEdge(v1);
		v1.removeEdge(v0);
		return(true);
	}

	log() {
		local l, l2, v;

		"Graph <<toString(self)>>:\n ";
		l = _vertexTable.keysToList().sort();
		if(l.length < 1) {
			"\tno vertices\n ";
			return;
		}
		l.forEach(function(o) {
			"\tvertex <q><<o>></q>:\n ";
			v = getVertex(o);
			l2 = v._edgeTable.keysToList().sort();
			l2.forEach(function(e) {
				"\t\tedge <q><<e>></q>\n ";
			});
		});
	}

	initializeGraph() {}
;
