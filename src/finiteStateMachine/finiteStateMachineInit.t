#charset "us-ascii"
//
// finiteStateMachineInit.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataStructures.h"

finiteStateMachineInit: InitObject
	execBeforeMe = static [ graphInit ]
	execute() {
		forEachInstance(FiniteStateMachine,
			{ x: x.initializeFiniteStateMachine() });
	}
;
