#charset "us-ascii"
//
// markovState.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataStructures.h"

#ifdef MARKOV_CHAINS

class MarkovState: StateMachineState
	// Return all the MarkovTransition instances associated
	// with this state.
	getTransitions() { return(getEdges()); }

	// Pick a random transition from this state.  Optional arg
	// is a PRNG instance to do the picking.
	pickTransition(prng?) {
		local l, v, w;

		// Get all our options.
		l = getTransitions();

		// v is for vertex IDs, w is for transition weights.
		v = new Vector(l.length);
		w = new Vector(l.length);

		// Build the two lists.
		l.forEach(function(o) {
			v.append(o.vertex1.vertexID);
			w.append(o.getWeight());
		});

		// Use the library function for a weighted random
		// pick.
		return(randomElementWeighted(v, w, prng));
	}
;

#endif // MARKOV_CHAINS
