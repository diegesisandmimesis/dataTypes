#charset "us-ascii"
//
// graphCheeger.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataStructures.h"

#ifdef GRAPH_CHEEGER

#include <bignum.h>

modify Graph
	// Prop to hold the computed value.
	cheegerConstant = nil

	graphUpdated() {
		clearCheegerConstant();
		inherited();
	}

	clearCheegerConstant() { cheegerConstant = nil; }

	getCheegerConstant() {
		local d, r, t;

		if(cheegerConstant != nil)
			return(cheegerConstant);

		// We'll use this to keep track of the minimum degree.
		r = nil;

		// Find the minimum degree.
		getVertices().forEach(function(v) {
			d = v.getDegree();
			if((r == nil) || (d < r))
				r = d;
		});

		t = getEdges().length();

		cheegerConstant = new BigNumber(r) / new BigNumber(t);

		return(cheegerConstant);
	}
;


#endif // GRAPH_CHEEGER
