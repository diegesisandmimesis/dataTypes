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
class FiniteStateMachineState: object
	stateID = nil
	active = true

	isActive = (active == true)
	getActive = (isActive())
	setActive(v) { active = v; }

	getStateID() { return(stateID); }
	setStateID(v) { stateID = v; }

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
class FiniteStateMachine: object
	currentState = nil		// Current state
	_stateTable = nil		// Table of all states

	// Class for states
	stateClass = FiniteStateMachineState

	// Add the given state to our table.
	addState(obj) {
		local id;

		// Make sure the arg is valid.
		if((obj == nil) || !obj.ofKind(stateClass))
			return(nil);

		// If the table doesn't exist, create it.
		if(_stateTable == nil)
			_stateTable = new LookupTable();

		// Store the state to the table, indexed by its ID.
		id = obj.getStateID();
		_stateTable[id] = obj;

		return(true);
	}

	// Getter and setter methods.
	getState() { return(currentState); }
	getStateID()
		{ return(currentState ? currentState.getStateID() : nil); }
	setState(v) { currentState = ((v & v.ofKind(stateClass)) ? v : nil); }

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
		if(_stateTable == nil) return;
		l = _stateTable.valsToList();
		if((l == nil) || (l.length < 1)) return;
		currentState = l[1];
	}
;

class FSM: FiniteStateMachine;
