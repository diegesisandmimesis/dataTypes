#charset "us-ascii"
//
// rule.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

class Rule: RulebookObject
	ruleID = nil		// ID for this rule

	rulebook = nil		// rulebook we're in

	construct(id, v?) {
		ruleID = id;
		if(v != nil) defaultValue = v;
	}

	initializeRule() {
		if(isRulebook(rulebook))
			return(rulebook.addRule(self));
		if(isRulebook(location))
			return(location.addRule(self));
		return(nil);
	}

	getRulebook() { return(rulebook); }
;
