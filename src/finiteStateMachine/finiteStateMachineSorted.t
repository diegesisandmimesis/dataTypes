#charset "us-ascii"
//
// finiteStateMachineSorted.t
//
//	Extensions to the base FSM logic to order states.
//
//
#include <adv3.h>
#include <en_us.h>

#include "dataStructures.h"

class FiniteStateMachineStateSorted: FSMState
	order = nil		// Integer order for this state
	_defaultOrder = 99	// Default order if none is given

	// Update for the base method.
	initFiniteStateMachineState() {
		inherited();
		_canonicalizeOrder();
	}

	// Make sure we have an order.  If one is explicitly declared on
	// the state we use it.  Otherwise we use the default value.
	_canonicalizeOrder() {
		switch(dataTypeXlat(order)) {
			case TypeSString:
				order = toInteger(order);
				break;
			case TypeInt:
				break;
			default:
				order = _defaultOrder;
				break;
		}
	}
;

class FSMStateSorted: FiniteStateMachineSorted;

class FiniteStateMachineSorted: FSM
	stateClass = FSMStateSorted

	// Tweak to base method.
	addState(obj) {
		if(!inherited(obj))
			return(nil);

		// If the state doesn't already have an order, we give
		// it one based on the order it was added to our table.
		if(obj.order == nil)
			obj.order = getStates().length();

		return(true);
	}

	// Get the active state with the lowest numerical order.
	// If an arg is given it is a state ID, and the active state
	// immediately AFTER the state with the given ID (in the
	// list of states sorted by numeric order) is used.
	getNextState(fromID?) {
		local i, l;

		// Make sure we have states.
		l = getSortedStates();
		if(l.length < 1) return(nil);

		// If we weren't passed an ID, we just use the first
		// active state.
		if(fromID == nil)
			return(l[1]);

		// We DO have an ID, so we find it in the list of active
		// states.
		i = l.indexWhich({ x: x.getStateID() == fromID });

		// If that failed or if the ID is the last state, fail.
		if((i == nil) || (i == l.length))
			return(nil);

		// Return the next state.
		return(l[i + 1]);
	}

	// Returns a list of active states sorted by their numeric
	// order.
	getSortedStates() {
		local l;

		l = getStates().subset({ x: x.isActive() });
		l = l.sort(true, { a, b:
			nilToInt(a.order, 99) - nilToInt(b.order, 99) });
		return(l);
	}
;

class FSMSorted: FiniteStateMachineSorted;
