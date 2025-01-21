#charset "us-ascii"
//
// markovChain.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

#ifdef MARKOV_CHAINS

class MarkovChain: StateMachine
	// Base weight to use when converting decimal probabilities.
	// We always want to use integers because floating point in TADS3 is
	// _slow_.  So we allow weights to be declared as 0.75 and 0.25, for
	// example, and then we'd multiply that by the base weight to get
	// an integer weight:  750 and 250, respectively.
	markovBaseWeight = 1000

	// Our bespoke vertex and edge classes
	stateClass = MarkovState
	transitionClass = MarkovTransition

	// PRNG instance used for picking random transitions.
	_prng = nil

	// Initialization vector, used for picking starting state.
	_markovIV = nil		

	preinitGraph() {
		// Before we do anything else we tweak the decimal percentages
		// if we have to.
		if(!_initializeMarkovMatrix()) return(nil);

		// Then do normal graph initialization.
		if(!inherited()) return(nil);

		// And finally we set up the initialization vector.
		if(!_initializeMarkovIV()) return(nil);

		return(true);
	}

	createEdge(v0, v1, v) {
		local r;

		r = inherited(v0, v1, v);
		r.markovBaseWeight = markovBaseWeight;
	}

	// This is where we convert the edge matrix.  In a normal graph
	// the values are interpreted as edge lengths.  Here we use them
	// for transition weights.  We also want to allow declarations using
	// decimal probabilities, and here's where we convert them into
	// integer weights.
	_initializeMarkovMatrix() {
		local l;

		// Make sure we have both a vertex list and an edge matrix.
		if(!isCollection(_vertexList) || !isCollection(_edgeMatrix))
			return(nil);

		// Make sure the matrix is square.
		l = _vertexList.length();
		if(_edgeMatrix.length != (l * l)) return(nil);

		// Convert the values.
		_edgeMatrix = _markovProbabilityToWeight(_edgeMatrix);

		return(true);
	}

	// Handle the initialization vector.
	// This is used to decide which state to start out in.
	// The IV should be a vector whose elements are the probability
	// of each state/vertex being the starting one.
	_initializeMarkovIV(prng?) {
		local l;

		// No IV, nothing to do.
		if(_markovIV == nil) return(nil);

		// Make sure the IV is the same length as the vertex list.
		l = getVertices();
		if(_markovIV.length != l.length()) return(nil);

		// Convert the probabilities to weights, if necessary.
		_markovIV = _markovProbabilityToWeight(_markovIV);

		// Pick a random one and set it as the default state.
		setFSMState(randomElementWeighted(l, _markovIV,
			(prng ? prng : _prng)));

		return(true);
	}

	// Given a list of decimal probabilities, return a list of equivalent
	// integer weights.
	// If the base weight is 1000, then given [ 0.75, 0.25, 0 ] this will
	// return [ 750, 250, 0 ], for example.
	_markovProbabilityToWeight(v) {
		local r;

		// Make sure the arg is valid.
		if(!isCollection(v)) return(nil);

		// For the return value.
		r = new Vector(v.length);

		v.forEach(function(o) {
			// Make sure each element of the input is >= 0 and
			// <= 1.
			if((isObject(o) || isInteger(o))
				&& (o >= 0) && (o <= 1))
				r.append(toIntegerSafe(o * markovBaseWeight));
		});

		// If our results list isn't the same length as the input list
		// that means one or more elements wasn't a valid value,
		// so we fail by returning the original list.  This is will
		// for cases where the list is already integer weights, and
		// other failure modes will have to be checked for elsewhere.
		if(r.length == v.length) return(r);

		return(v);
	}

	getPRNG() { return(_prng); }
	setPRNG(v) {
		if(!isPRNG(v)) return(nil);
		_prng = v;
		return(true);
	}

	getWeight(v0, v1) {
		local e;

		if((e = getEdge(v0, v1)) == nil) return(nil);
		return(e.getWeight());
	}

	setWeight(v0, v1, w) {
		local e;

		if((e = getEdge(v0, v1)) == nil) return(nil);
		e.setWeight(w);
		return(true);
	}

	pickTransition(id?, prng?) {
		local v;

		if(id == nil)
			if((id = getFSMStateID()) == nil)
				return(nil);

		if((v = getVertex(id)) == nil) return(nil);
		if((id = v.pickTransition(prng ? prng : _prng)) == nil)
			return(nil);

		setFSMState(id);

		return(id);
	}
;

#endif // MARKOV_CHAINS
