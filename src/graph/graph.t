#charset "us-ascii"
//
// graph.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

class Graph: object
	// Boolean indicating if the graph is directed.
	directed = nil

	// Classes to use for vertices and edges.
	vertexClass = Vertex
	edgeClass = Edge

	// Table to hold our vertices.
	_vertexTable = perInstance(new LookupTable)

	// "Cache" objects for quicker lookups
	_edgeList = nil

	// Used for initialization.
	_vertexList = nil
	_edgeMatrix = nil

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
		obj.setGraph(self);
		graphUpdated();
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
		graphUpdated();

		return(true);
	}

	// Remove all our vertices.  We could just iterate over all our
	// vertices and their edges calling the various remove methods on them,
	// but since we're clearing everything out we can do it without worrying
	// about any of the (slower) bookkeeping.
	removeVertices() {
		getVertices().forEach({ x: x._edgeTable = nil });
		_vertexTable = new LookupTable();
	}

	// Given a vertex object or a valid vertex ID, return the matching
	// vertex object.
	// Used on Graph methods so they can take either an object or an
	// ID as an argument.
	canonicalizeVertex(v) {
		if(v == nil) return(nil);
		if(v.ofKind(vertexClass)) return(getVertex(v.vertexID));
		return(getVertex(v));
	}

	getVertices() { return(_vertexTable.valsToList()); }

	getVertexIDs() { return(_vertexTable.keysToList()); }

	forEachVertex(cb) { getVertices().forEach({ x: cb(x) }); }

	addEdge(id0, id1, obj?, recip?) {
		local v0, v1;

		if((id0 == nil) || (id1 == nil)) return(nil);
		if((v0 = canonicalizeVertex(id0)) == nil) return(nil);
		if((v1 = canonicalizeVertex(id1)) == nil) return(nil);

		if(!isEdge(obj))
			obj = edgeClass.createInstance(v0, v1);

		v0.addEdge(v1, obj);
		if((directed != true) || (recip == true))
			v1.addEdge(v0, obj);

		graphUpdated();

		return(obj);
	}

	getEdge(id0, id1) {
		local v0, v1;

		if((id0 == nil) || (id1 == nil)) return(nil);
		if((v0 = canonicalizeVertex(id0)) == nil) return(nil);
		if((v1 = canonicalizeVertex(id1)) == nil) return(nil);

		return(v0.getEdge(v1));
	}

	removeEdge(id0, id1) {
		local v0, v1;

		if((id0 == nil) || (id1 == nil)) return(nil);
		if((v0 = canonicalizeVertex(id0)) == nil) return(nil);
		if((v1 = canonicalizeVertex(id1)) == nil) return(nil);

		v0.removeEdge(v1);
		if(directed != true)
			v1.removeEdge(v0);

		graphUpdated();

		return(true);
	}

	getEdges() {
		local r;

		if(_edgeList != nil)
			return(_edgeList);

		r = new Vector();
		getVertices().forEach(function(v) {
			v.getEdges().forEach(function(e) {
				r.appendUnique(e);
			});
		});

		_edgeList = r;

		return(r);
	}

	forEachEdge(cb) { getEdges().forEach({ x: cb(x) }); }

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

	// Output the structure of the graph by enumerating the edges
	// with placeholder names.  Mostly useful if the vertices have
	// IDs like "vertex23512" and "vertex67321" and so on, like
	// happens with the procgen stuff.  This will just give
	// you a bunch of "a => b, b => c" statements which is a little
	// easier to read.
	logStructure() {
		local i, idx, lbl, swiz;

		// If we've got more than 72 vertices we're probably not
		// going to get anywhere scanning things visually anyway.
		if(getVertices().length > 72) {
			"\nToo many vertices to log this way.\n ";
			return;
		}

		// First create a list of labels, A-Z, a-z.
		lbl = new Vector;
		for(i = 0; i < 26; i++)
			lbl.append(makeString(65 + i));
		for(i = 0; i < 26; i++)
			lbl.append(makeString(97 + i));

		// Temporary swizzle table for the labels.
		swiz = new LookupTable();

		// Map all the vertex IDs to labels.
		idx = 1;
		forEachVertex({ x: swiz[x.vertexID] = lbl[idx++] });

		// Output all the edges using the short labels.
		forEachEdge(function(e) {
			"\n<<swiz[e.vertex0.vertexID]>>
				=&gt; <<swiz[e.vertex1.vertexID]>>\n ";
		});
	}

	graphUpdated() {
		_edgeList = nil;
	}

	// Handle "short form" graph declarations.  This is when
	// everything is in the Graph declaration itself, as opposed
	// to having separate +Vertex and +Edge declarations.
	preinitGraph() {
		if(!_initializeGraphVertexList()) return(nil);
		if(!_initializeGraphEdgeMatrix()) return(nil);
		return(true);
	}

	_initializeGraphVertexList() {
		if(_vertexList == nil) return(nil);

		_vertexList.forEach({ x: addVertex(x) });

		return(true);
	}

	_initializeGraphEdgeMatrix() {
		local e, i, j, l, off, v, v0, v1;

		if(_edgeMatrix == nil) return(nil);

		l = _vertexList.length;
		if(_edgeMatrix.length != (l * l)) return(nil);

		for(j = 1; j <= l; j++) {
			off = (j - 1) * l;
			for(i = 1; i <= l; i++) {
				v = _edgeMatrix[off + i];
				if(toInteger(v) == 0) continue;
				v0 = getVertex(_vertexList[j]);
				v1 = getVertex(_vertexList[i]);
				if((e = getEdge(v0, v1)) != nil) continue;
				e = createEdge(v0, v1, v);
				addEdge(v0, v1, e);
			}
		}

		return(true);
	}

	// Convenience method to make it easier for subclasses to decorate
	// newly-created edge instances.
	createEdge(v0, v1, len?, d?) {
		return(edgeClass.createInstance(canonicalizeVertex(v0),
			canonicalizeVertex(v1), len, d));
	}

	// Handle "long form" graph declarations.  This is when you have
	// a Graph declaration followed by +Vertex and/or +Edge
	// declarations.
	// Right now we don't do anything--it's all handled by the Vertex
	// and Edge declarations (but might not be for subclasses of Graph).
	initializeGraph() {}
;
