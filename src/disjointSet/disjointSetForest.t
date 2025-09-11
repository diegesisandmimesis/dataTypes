#charset "us-ascii"
//
// disjointSetForest.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

class DisjointSetForest: object
	_forest = nil

	makeSet(v) {
		return(add(DisjointSet.createInstance(v)));
	}

	add(v) {
		if(!isDisjointSet(v)) return(nil);
		if(_forest == nil) _forest = new Vector();
		_forest.append(v);
		v.forest = self;
		return(true);
	}

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

	_link(v0, v1) {
		local t;

		if(!isDisjointSet(v0) || !isDisjointSet(v1))
			return(nil);
		if(v0.rank > v1.rank) {
			t = v1;
			v1 = v0;
			v0 = t;
		}
		if(v0.rank == v1.rank)
			v1.rank += 1;
		v0.parent = v1;
		return(v1);
	}

	union(v0, v1) {
		return(_link(find(v0), find(v1)));
	}

	forEachSet(fn) {
		if(!isFunction(fn) || (_forest == nil)) return(nil);
		_forest.forEach({ x: fn(x) });
		return(true);
	}

	log() {
#ifdef __DEBUG
		forEachSet({ x:
			"\n<<toString(x.id)>>: <<toString(find(x.id).id)>>\n "
		});
#endif // __DEBUG
	}
;
