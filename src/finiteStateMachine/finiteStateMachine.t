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

	stateMachine = (_graph)

	isActive = (active == true)
	getActive = (isActive())
	setActive(v) { active = v; }

	getStateID() { return(stateID); }

	getStateMachine() { return(stateMachine); }
;

// Convenience class;  just supplies a shorter name.
class FSMState: FiniteStateMachineState;
class StateMachineState: FiniteStateMachineState;

// Basic state machine.
class FiniteStateMachine: DirectedGraph
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

	// Set the current state.  This is the "just do it" method--it
	// doesn't do any checking or bookkeeping.  Most callers
	// probably want toState() (below) instead.
	setState(v) {
		v = canonicalizeVertex(v);
		currentState = ((v && v.ofKind(stateClass)) ? v : nil);
	}

	// Change to the given state.  This method implements checks and
	// does bookkeeping, and so is _probably_ what most callers should
	// use instead of setState() above.
	toState(id) {
		local e, v0, v1;

		// Make sure we have a current state.  No current state,
		// no valid transitions.
		if((v0 = getState()) == nil) return(nil);

		// Make sure the requested ID is a valid vertex.
		if((v1 = canonicalizeVertex(id)) == nil) return(nil);

		// Make sure the requested new state is reachable from
		// the current state.
		if((e = v0.getEdge(v1)) == nil) return(nil);

		// Set it.
		setState(v1);

		// Return the edge we used to get there.
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
class StateMachine: FiniteStateMachine;

class Transition: DirectedEdge;
