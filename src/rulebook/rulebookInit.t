#charset "us-ascii"
//
// rulebookInit.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataStructures.h"

#ifdef RULEBOOK

rulebookPreinit: PreinitObject
	execute() {
		forEachInstance(Rule, { x: x.initializeRule() });
		forEachInstance(Rulebook, { x: x.initializeRulebook() });
	}
;

#endif // RULEBOOK
