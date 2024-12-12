#charset "us-ascii"
//
// finiteStateMachineInit.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataStructures.h"

finiteStateMachineInit: InitObject
	execute() {
		forEachInstance(FiniteStateMachineState,
			{ x: x.initializeFiniteStateMachineState() });
		forEachInstance(FiniteStateMachine,
			{ x: x.initializeFiniteStateMachine() });
	}
;
