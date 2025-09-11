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

	_vertexLabels = nil

	// Add a vertex to the graph.
	//	addVertex(foo);		If foo is a Vertex instance, add it
	//	addVertex('foo', foo);	Add Vertex instance foo with ID 'foo'
	//	addVertex('foo');	Create new Vertex instance, add it
	//				with ID 'foo'
	addVertex(id, obj?) {
		if(id == nil)
			return(nil);

		if(isString(id) && (getVertex(id) != nil))
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

		forEachVertex({ x: x.removeEdge(v) });
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
		graphUpdated();
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

	getOrder() { return(getVertices().length()); }

	// Returns boolean true if the given callback fn returns true
	// for each vertex.
	testVertices(cb) {
		local l;
		l = getVertices();
		return(l.subset({ x: ((cb)(x) == true) }).length == l.length);
	}

	addEdge(id0, id1, obj?, recip?) {
		local v0, v1;

		if((id0 == nil) || (id1 == nil)) return(nil);
		if((v0 = canonicalizeVertex(id0)) == nil) return(nil);
		if((v1 = canonicalizeVertex(id1)) == nil) return(nil);

		if(getEdge(v0.vertexID, v1.vertexID) != nil)
			return(nil);

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

	adjacencyMatrix(lst?) {
		local l, m, r, v, x, y;

		l = getVertexIDs().sort();
		if(isCollection(lst) && (lst.length == l.length))
			l = lst;

		m = new IntegerMatrix(l.length, l.length);
		m.fill(0);
		l.forEach(function(id) {
			if((y = l.indexOf(id)) == nil) return;
			if((v = getVertex(id)) == nil) return;
			v.getEdgeIDs().forEach(function(eid) {
				local e;
				if((x = l.indexOf(eid)) == nil) return;
				if((e = getEdge(id, eid)) == nil) return;
				m.set(x, y, e.getLength);
			});
		});

		r = new AdjacencyMatrix(l, m);

		return(r);
	}

	// Clear anything we've cached.
	graphUpdated() {
		_edgeList = nil;
	}

	// Removed all vertices and edges without cleaning anything
	// up.  Intended to be used after a destructive join.
	hardReset() {
		_vertexTable = new LookupTable();
		graphUpdated();
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

	// Adds all the edges and vertices from graph g to this graph,
	// connecting them at v0 (on our side) and v1 (on g's side).
	// If recip is true, then we also connect v1 to v0 (assuming
	// we're directed; if we're undirected that happens automagically).
	// The destruct flag indicates whether we should create new
	// vertices (creating a copy of g and adding it to ourselves)
	// or if we plunder g's edge and vertex instances and use them
	// directly, removing them from g in the process.
	join(g, v0, v1, recip?, destruct?) {
		local i, l;

		// Validate the arguments.
		if(!isGraph(g)) return(nil);
		if((v0 = canonicalizeVertex(v0)) == nil) return(nil);
		if((v1 = g.canonicalizeVertex(v1)) == nil) return(nil);

		// Make sure we don't have any duplicate IDs in the
		// graph we're merging with.  If we do, just fail.
		l = g.getVertices();
		for(i = 1; i <= l.length; i++) {
			if(getVertex(l[i].vertexID) != nil)
				return(nil);
		}

		// See if we're doing a destructive join.
		if(destruct == true) {
			// First, move all the vertices over.
			l.forEach({ x: addVertex(x.vertexID, x) });

			// Now move the edges over.
			l.forEach(function(v) {
				v.getEdgeIDs().forEach(function(eid) {
					local e;
					if((e = g.getEdge(v.vertexID, eid))
						== nil)
						return;
					addEdge(v.vertexID, eid, e);
				});
			});

			// Purge the old graph.
			g.hardReset();
		} else {
			// Create the new vertices.
			l.forEach({ x: addVertex(x.vertexID) });

			// Add the edges.
			l.forEach(function(v) {
				v.getEdgeIDs().forEach(function(eid) {
					addEdge(v.vertexID, eid);
				});
			});
		}

		// Add the connection between the existing graph and
		// the new subgraph.
		addEdge(v0.vertexID, v1.vertexID);

		// If we're a directed graph and we've been asked to
		// make the connection reciprocal, do so.
		if((recip == true) && (directed == true))
			addEdge(v1.vertexID, v0.vertexID);

		// Done.
		return(true);
	}

	// Merge vertex v1 onto v0.
	mergeVertices(v0, v1) {
		if((v0 = canonicalizeVertex(v0)) == nil) return(nil);
		if((v1 = canonicalizeVertex(v1)) == nil) return(nil);
		v1.getEdgeIDs().forEach(function(eid) {
			if(eid == v0.vertexID) return;
			addEdge(v0, eid);
			v1.removeEdge(canonicalizeVertex(eid));
		});
		forEachVertex(function(v) {
			if(v == v0) return;
			v.getEdgeIDs().forEach(function(eid) {
				if(eid != v1.vertexID) return;
				addEdge(v, v0);
			});
			v.removeEdge(v1);
		});
		removeVertex(v1);
		return(true);
	}

	// Handle "long form" graph declarations.  This is when you have
	// a Graph declaration followed by +Vertex and/or +Edge
	// declarations.
	// Right now we don't do anything--it's all handled by the Vertex
	// and Edge declarations (but might not be for subclasses of Graph).
	initializeGraph() {}

	vertexLabel(v) {
		local i, idx;

		if(!isVertex(v)) return(nil);
		if((idx = getVertices().indexOf(v)) == nil) return(nil);
		if(_vertexLabels == nil) {
			_vertexLabels = new Vector();
			for(i = 0; i < 26; i++)
				_vertexLabels.append(makeString(65 + i));
			for(i = 0; i < 26; i++)
				_vertexLabels.append(makeString(97 + i));
			_vertexLabels = _vertexLabels.toList();
		}

		while(idx > _vertexLabels.length)
			idx -= _vertexLabels.length;

		return(_vertexLabels[idx]);
	}

	// Returns a shallow copy of this graph.
	clone() {
		local r;

		r = new Graph();

		forEachVertex({ v: r.addVertex(v.vertexID) });
		forEachEdge({
			e: r.addEdge(e.vertex0.vertexID, e.vertex1.vertexID)
		});

		return(r);
	}
;
