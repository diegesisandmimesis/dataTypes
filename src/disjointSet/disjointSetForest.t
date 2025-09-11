#charset "us-ascii"
//
// disjointSetForest.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

class DisjointSetForest: object
	_forest = nil		// list of all our disjoint-sets

	// Create a new disjoint-set instance with the given ID.
	makeSet(v) { return(add(DisjointSet.createInstance(v))); }

	// Add a DisjointSet instance to our list.
	add(v) {
		if(!isDisjointSet(v)) return(nil);
		if(_forest == nil) _forest = new Vector();
		_forest.append(v);
		return(true);
	}

	// Return the top-level parent of the given disjoint-set.
	// Argument can be a DisjointSet instance or an ID.
	// Return value will be a DisjointSet instance.
	find(v) {
		if(isString(v))
			v = getDisjointSet(v);
		if(!isDisjointSet(v))
			return(nil);
		if(v.parent == v)
			return(v);
		v.parent = find(v.parent);
		return(v.parent);
	}

	// Given an ID, return the corresponding DisjointSet instance
	// if there is one in this forest.
	getDisjointSet(id) {
		local i;

		if(_forest == nil)
			return(nil);

		for(i = 1; i <= _forest.length; i++) {
			if(_forest[i].id == id)
				return(_forest[i]);
		}

		return(nil);
	}

	// Utility method for linking two disjoint sets, changing parents
	// and incrementing ranks if necessary.
	_link(v0, v1) {
		local t;

		if(!isDisjointSet(v0) || !isDisjointSet(v1))
			return(nil);

		// Simple canonicalization; higher ranks are preferred as
		// parents and we always make the second instance the
		// parent, so if the first instance has a higher rank we
		// swap them.
		if(v0.rank > v1.rank) {
			t = v1;
			v1 = v0;
			v0 = t;
		}

		// If the ranks are the same, we promote the second instance.
		if(v0.rank == v1.rank)
			v1.rank += 1;

		// The second instance is the parent.
		v0.parent = v1;

		return(v1);
	}

	// Join the two disjoint-sets.
	union(v0, v1) { return(_link(find(v0), find(v1))); }

	// Utility method.
	forEachSet(fn) {
		if(!isFunction(fn) || (_forest == nil)) return(nil);
		_forest.forEach({ x: fn(x) });
		return(true);
	}

	// Debugging method.  Just lists all the nodes and their parents.
	log() {
#ifdef __DEBUG
		forEachSet({ x:
			"\n<<toString(x.id)>>: <<toString(find(x.id).id)>>\n "
		});
#endif // __DEBUG
	}
;
