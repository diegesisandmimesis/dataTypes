#charset "us-ascii"
//
// markovTransition.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

#ifdef MARKOV_CHAINS

class MarkovTransition: Transition
	// Base transition weight.  Used when converting from
	// decimal probabilities.
	// Overridden by the same property on the parent MarkovChain
	// when the chain is declared using the short form syntax (using
	// a vertex list and edge matrix).
	markovBaseWeight = 1000

	getWeight() { return(getLength()); }
	setWeight(v) { return(setLength(v)); }

	initializeEdge() {
		inherited();
		_fixMarkovWeight();
	}

	// Check to see if the edge length is a decimal number between
	// 0 and 1 and if so treat it as a decimal probability and
	// turn it into an integer weight.
	_fixMarkovWeight() {
		// Decimal numbers will be objects and 0 or 1 will be
		// integers.
		if(!isObject(length) && !isInteger(length))
			return;

		// If the length isn't between 0 and 1, it's not a
		// decimal probability, so we have nothing to do.
		if((length == 0) || (length > 1))
			return;

		length = toIntegerSafe(length * markovBaseWeight);
	}
;

#endif // MARKOV_CHAINS
