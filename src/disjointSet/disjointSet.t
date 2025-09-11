#charset "us-ascii"
//
// disjointSet.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

class DisjointSet: object
	id = nil
	parent = nil
	rank = 0
	forest = nil

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
