#charset "us-ascii"
//
// btStack.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

// Stack for recursive backtracker.
class BTStack: object
	syslogID = 'BTStack'

	stackFrameClass = nil			// class for stack frames
	_stack = perInstance(new Vector())	// our stack

	// Clear the stack.
	clear() { _stack = new Vector(); }

	// Add a frame to the stack.
	push(v) {
		if(!validateFrame(v)) return(nil);
		_stack.push(v);
		return(true);
	}

	// Lift the top frame off the stack.
	pop() { return(_stack.pop()); }

	// Make sure the frame is valid.
	validateFrame(v) {
		if(stackFrameClass != nil)
			return((v != nil) && v.ofKind(stackFrameClass));
		return(true);
	}
;
