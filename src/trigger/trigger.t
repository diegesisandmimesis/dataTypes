#charset "us-ascii"
//
// trigger.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

// A Trigger is a Rule that is also a Tuple.
class Trigger: Rule, Tuple
	_triggerTuple = nil		// remember the tuple we matched

	match(data?) {
		local t;

		// We always reset the remembered tuple
		_triggerTuple = nil;

		// Merge this turn's tuple with whatever we were passed.
		t = gTuple(data);

		// If what we got above doesn't match us, we're done.
		if(!matchTuple(t)) return(nil);

		// We DID match, so remember what we matched.
		_triggerTuple = t;

		return(true);
	}

	getTriggerSrcObject()
		{ return(_triggerTuple ? _triggerTuple.srcObject : nil); }
	getTriggerDstObject()
		{ return(_triggerTuple ? _triggerTuple.dstObject : nil); }
	getTriggerSrcActor()
		{ return(_triggerTuple ? _triggerTuple.srcActor : nil); }
	getTriggerDstActor()
		{ return(_triggerTuple ? _triggerTuple.dstActor : nil); }
	getTriggerAction()
		{ return(_triggerTuple ? _triggerTuple.action : nil); }
	getTriggerRoom()
		{ return(_triggerTuple ? _triggerTuple.room : nil); }
;

class ExtendedTrigger: Trigger
	match(data?) {
		if(inherited(data) != true) return(nil);
		return(checkTrigger(data));
	}
	checkTrigger(data?) { return(true); }
;

class ExTrigger: ExtendedTrigger;
