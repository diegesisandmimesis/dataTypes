#charset "us-ascii"
//
// disjointSet.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

class DisjointSet: object
	id = nil		// unique-ish ID
	parent = nil		// parent node
	rank = 0		// our rank

	construct(v) {
		id = v;
		init();
	}

	init() {
		parent = self;
		rank = 0;

		return(true);
	}


;
