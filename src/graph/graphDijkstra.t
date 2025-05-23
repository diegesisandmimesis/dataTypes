#charset "us-ascii"
//
// graphDijkstra.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

modify Graph
	_dijkstraCache = nil		// tmp cache for computing paths
	_dijkstraMaxPathLen = nil	// cached value of longest path
	_dijkstraLock = nil		// lock flag for computing longest path

	_dijkstraMax = 65535

	graphUpdated() {
		inherited();
		clearDijkstraCache();
	}

	clearDijkstraCache() {
		_dijkstraCache = nil;
		_dijkstraMaxPathLen = nil;
		_dijkstraLock = nil;
	}

	initDijkstraCache() {
		_dijkstraCache = new LookupTable();
		_dijkstraMaxPathLen = nil;
		_dijkstraLock = nil;
	}

	// Returns the path between vertices v0 and v1.
	getDijkstraPath(v0, v1) {
		local h, r, v;

		// Make sure we've got something we can understad as a pair
		// of vertices.
		if((v0 = canonicalizeVertex(v0)) == nil) return(nil);
		if((v1 = canonicalizeVertex(v1)) == nil) return(nil);

		// Query the Dijkstra cache for its data on the given
		// starting vertex.  This will compute it if it isn't
		// in the cache.
		// The data will contain paths to other vertices,
		// so the rest of what we do here is just getting
		// the path information we care about.
		if((h = queryDijkstraHash(v0)) == nil) return(nil);

		// Make sure the path information for this starting
		// vertex includes a path to the end vertex.  If not,
		// fail.
		if((v = h[v1.vertexID]) == nil) return(nil);

		r = new Vector([ v, v1.vertexID ]);
		while(v) {
			if(v == v0.vertexID) return(r);
			if(h[v])
				r.prepend(h[v]);
			v = h[v];
		}

		return(nil);
	}

	// Given a list of vertices and a Dijkstra hash, determine which vertex
	// has the shortest path length.
	computeDijkstraMin(r, hash) {
		local i, id, min;

		if(!r || !r.length || !hash)
			return(nil);
		
		// Start out with the first vertex.
		id = r[1];
		min = hash[r[1]];

		// If we only have one element, done.
		if(r.length < 2)
			return(id);

		// Check the rest of the vertices.
		for(i = 2; i <= r.length; i++) {
			// Shouldn't happen.
			if(hash[r[i]] == nil)
				continue;

			// If this one's shorter, remember it.
			if(min > hash[r[i]]) {
				min = hash[r[i]];
				id = r[i];
			}
		}

		return((min != nil) ? id : nil);
	}

	// Returns the Djijkstra hash for the given vertex, computing
	// it if necessary.
	queryDijkstraHash(id0) {
		local alt, dHash, e, prevHash, i, id, idx, l, r, v;

		// Make sure we've got a valid vertex.
		if((v = canonicalizeVertex(id0)) == nil)
			return(nil);
		id0 = v.vertexID;

		// If the cache contains the hash for the requested vertex
		// return it and we're done.
		if(_dijkstraCache && _dijkstraCache[id0])
			return(_dijkstraCache[id0]);

		// Create the storage for the new result.
		dHash = new LookupTable();
		prevHash = new LookupTable();
		r = new Vector();

		// We start out by setting the distances to all vertices
		// arbitrary high.  We simultaneously add every vertex ID
		// to a list that we'll use to keep track of what we
		// still have to check.
		l = getVertices();
		for(i = 1; i <= l.length; i++) {
			dHash[l[i].vertexID] = _dijkstraMax;
			prevHash[l[i].vertexID] = nil;
			r.append(l[i].vertexID);
		}

		// The distance from the source vertex to itself is zero.
		dHash[id0] = 0;

		// We loop as long as we have un-checked vertices.
		while(r.length > 0) {
			// Check our results so far to find the closest
			// unchecked vertex.
			id = computeDijkstraMin(r, dHash);

			// Make sure the next candidate is a valid vertex.
			if((v = canonicalizeVertex(id)) == nil)
				return(nil);

			// Remove this vertex from our list of unchecked
			// vertices because we're about to check it.
			if((idx = r.indexOf(id)) != nil)
				r.removeElementAt(idx);

			// Loop over all of the edges of the new vertex.
			l = v.getEdgeIDs();
			for(i = 1; i <= l.length(); i++) {
				// Distance to the far side of the edge
				// is the distance to this vertex plus the edge
				// length, unless we've already found a
				// shorter path.
				e = v._edgeTable[l[i]];
				alt = toInteger(dHash[id]) + e.getLength();
				if(alt < toInteger(dHash[l[i]])) {
					dHash[l[i]] = alt;
					// Path back from far side of the
					// edge to this vertex.
					prevHash[l[i]] = id;
				}
			}
		}

		// Make sure we have a cache to save our result to.
		if(_dijkstraCache == nil)
			initDijkstraCache();

		// Save it.
		_dijkstraCache[id0] = prevHash;

		// Return.
		return(prevHash);
	}

	getDijkstraDistances(id0) {
		local alt, dHash, e, i, id, idx, l, r, v;

		if((v = canonicalizeVertex(id0)) == nil)
			return(nil);
		id0 = v.vertexID;

		dHash = new LookupTable();
		//prevHash = new LookupTable();
		r = new Vector();

		l = getVertices();
		for(i = 1; i <= l.length; i++) {
			dHash[l[i].vertexID] = _dijkstraMax;
			//prevHash[l[i].vertexID] = nil;
			r.append(l[i].vertexID);
		}

		dHash[id0] = 0;

		while(r.length > 0) {
			id = computeDijkstraMin(r, dHash);

			if((v = canonicalizeVertex(id)) == nil)
				return(nil);

			if((idx = r.indexOf(id)) != nil)
				r.removeElementAt(idx);

			l = v.getEdgeIDs();
			for(i = 1; i <= l.length(); i++) {
				e = v._edgeTable[l[i]];
				alt = toInteger(dHash[id]) + e.getLength();
				if(alt < toInteger(dHash[l[i]])) {
					dHash[l[i]] = alt;
					//prevHash[l[i]] = id;
				}
			}
		}

		l = dHash.keysToList();
		l.forEach(function(x) {
			if(dHash[x] == _dijkstraMax)
				dHash.removeElement(x);
		});

		return(dHash);
	}

	getLongestPath(id?) {
		// If we've already computed it, return the value.
		if(_dijkstraMaxPathLen != nil)
			return(_dijkstraMaxPathLen);

		// Braindead mutex-like thing.
		if(_dijkstraLock != nil) return(nil);
		_dijkstraLock = true;

		// Clear the flag on each vertex.
		getVertices().forEach({ x: x._dijkstraFlag = nil });

		_dijkstraMaxPathLen = _longestPath(id ? id
			: getVertices()[1].vertexID);

		// Clear our lock.
		_dijkstraLock = nil;

		return(_dijkstraMaxPathLen);
	}

	// Naive longest path algorithm.
	// Should work for most IF maps, which should have more than a
	// couple hundred vertices.
	_longestPath(id) {
		local d, max, v0, v1;

		// Vertex isn't in graph, no path.
		if((v0 = getVertex(id)) == nil) return(0);

		// Longest path we know of is no path at all.
		max = 0;

		// Mark the first vertex as "visited".
		v0._dijkstraFlag = true;

		v0.getEdgeIDs().forEach(function(o) {
			if((v1 = getVertex(o)) == nil) return;

			// If we've "visited" this vertex, skip it.
			if(v1._dijkstraFlag == true) return;

			// Compute the length of then longest path involving
			// this vertex by recursively computing the length
			// of the longest path involving each of its unchecked
			// neighbors and adding one to that.
			d = 1 + _longestPath(o);
			if(d > max) max = d;
		});

		// Clear the flag on this vertex, so other vertices can
		// path through us.
		v0._dijkstraFlag = nil;

		return(max);
	}
;
