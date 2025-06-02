#charset "us-ascii"
//
// bt.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

// (Fairy) generic recursive backtracker.
class BT: object
	syslogID = 'BT'

	frameClass = BTFrame		// class for stack frames
	stackClass = BTStack		// class for the stack
	_stack = nil			// the stack instance

	// Stack getter and setter.  Automagically creates the stack
	// instance if it doesn't exist.
	getStack() {
		if(_stack == nil) _stack = stackClass.createInstance();
		return(_stack);
	}
	setStack(v) { return(isBTStack(v) && ((_stack = v) != nil)); }
	clearStack() { getStack().clear(); }

	// Returns the top frame of the stack.
	pop() { return(getStack().pop()); }
	push(v) { return(getStack().push(v)); }

	// Generic rejection method.  Should only return true if all
	// frames derived from the argument frame will be invalid.
	// By default we only reject if the arg is not a valid frame
	// (probably because we ran out of iterations and got a nil).
	reject(frm) { return(!isBTFrame(frm)); }

	// Acceptance method. Here we just check that the results
	// vector is a full permutation...that is, it has an assignment
	// for each entry in vList.  Individual subclasses will want to
	// implement task-specific checks on top of this.
	// NOTE: this method is asking "have we found the answer", not
	//	"is this a valid frame".
	accept(frm) {
		if((frm.result == nil)
			|| (frm.result.length < frm.vList.length))
			return(nil);
		return(true);
	}

	// Returns the next frame after the argument frame.
	next(frm) { return(frm.next()); }

	// Advance a single step.
	// Returns nil if the frame is a permanent failure,
	// true if it is accepted (that is, the solution was found),
	// the next frame if one is available, and nil if we're
	// out of frames.
	step(frm) {
		if(reject(frm)) {
			return(nil);
		}
		if(accept(frm)) {
			push(frm);
			return(true);
		}
		if((frm = next(frm)) != nil) {
			return(frm);
		}

		return(nil);
	}
	
	// Run until we accept reject, accept, or run out of frames.
	// Implemented as a while loop instead of tail recursion to
	// avoid making the T3VM throw an exception due to stack
	// exhaustion on deep searches.
	run(frm) {
		while((frm = step(frm)) != nil) {
			if(frm == true)
				return(true);
		}
		return(nil);
	}
;
