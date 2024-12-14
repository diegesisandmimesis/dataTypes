#charset "us-ascii"
//
// finiteStateMachine.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataStructures.h"

// Basic state.
// In its simples form a state is just an ID and a flag to indicate
// whether or not the state is active.
class FiniteStateMachineState: Vertex
	stateID = (vertexID)
	active = true

	isActive = (active == true)
	getActive = (isActive())
	setActive(v) { active = v; }

	getStateID() { return(stateID); }

	initializeFiniteStateMachineState() {
		if((location == nil)
			|| !location.ofKind(FiniteStateMachine))
			return;

		location.addState(self);
	}
;

// Convenience class;  just supplies a shorter name.
class FSMState: FiniteStateMachineState;

// Basic state machine.
// This machine consists only of a table of possible states, of which
// at any time either exactly one or none are the current state.
// The latter--allowing the state machine to have a null state--is
// probably a misfeature, but it's implemented this way to make failures
// a little more graceful (hopefully).  Specifically this is to handle the
// case of state machines that are declared but never initialized.
class FiniteStateMachine: Graph
	directed = true
	vertexClass = (stateClass)
	edgeClass = (transitionClass)
	currentState = nil		// Current state

	// Class for states
	stateClass = FiniteStateMachineState
	transitionClass = Transition

	// Add the given state to our table.
	addState(obj) { return(addVertex(obj)); }

	// Getter and setter methods.
	getState() { return(currentState); }
	getStateID()
		{ return(currentState ? currentState.getStateID() : nil); }

	setState(v) {
		v = canonicalizeVertex(v);
		currentState = ((v && v.ofKind(stateClass)) ? v : nil);
	}

	toState(id) {
		local e, v0, v1;

		if((v0 = getState()) == nil) return(nil);
		if((v1 = canonicalizeVertex(id)) == nil) return(nil);
		if((e = v0.getEdge(v1)) == nil) return(nil);
		setState(v1);
		return(e);
	}

	getStates() { return(_vertexTable.valsToList()); }

	// Init-time method.
	initializeFiniteStateMachine() {
		setInitialState();
	}

	// Basic logic for determining the initial state.  If one isn't
	// explicitly declared we pick the first one we get.  This
	// will USUALLY be the one declared first in source, but if that's
	// important it should be made explicit.
	setInitialState() {
		local l;

		if(currentState != nil) return;
		l = getStates();
		if((l == nil) || (l.length < 1)) return;
		currentState = l[1];
	}
;

class FSM: FiniteStateMachine;

class Transition: Edge;
