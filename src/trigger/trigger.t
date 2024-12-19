#charset "us-ascii"
//
// trigger.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataStructures.h"

#ifdef TRIGGER

class Trigger: Rule, Tuple
	match(data?) { return(matchTuple(gTuple(data))); }
;

#endif // TRIGGER
