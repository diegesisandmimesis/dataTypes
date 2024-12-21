#charset "us-ascii"
//
// trigger.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataStructures.h"

// A Trigger is a Rule that is also a Tuple.
class Trigger: Rule, Tuple
	match(data?) { return(matchTuple(gTuple(data))); }
;
