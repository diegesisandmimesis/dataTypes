#charset "us-ascii"
//
// rulebook.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataStructures.h"

class Rulebook: RulebookObject
	rulebookID = nil

	_rulebook = perInstance(new Vector())

	addRule(obj) {
		if(!isRule(obj)) return(nil);
		_rulebook.append(obj);
		obj.rulebook = self;
		return(true);
	}

	removeRule(obj) {
		if(_rulebook.indexOf(obj) == nil) return(nil);
		_rulebook.removeElement(obj);
		return(true);
	}

	initializeRulebook() {}

	// Evaluate all our rules.
	// By default we return the default value unless all rules are
	// true.
	match(data?) {
		local i;

		for(i = 1; i <= _rulebook.length; i++) {
			if(checkRule(_rulebook[i], data) != true)
				return(defaultValue);
		}

		return(!defaultValue);
	}

	// How we check an individual rule.
	// This is broken out into its own method so subclasses can do
	// other things (like only calling eval() during specific phases of
	// the turn lifecycle).
	checkRule(obj, data?) {
		if(!isRule(obj)) return(nil);
		obj.eval(data);
		return(obj.getValue());
	}
;

// Rulebook whose default value is nil, and becomes true if ANY of its
// rules are true.
class RulebookMatchAny: Rulebook
	defaultValue = nil

	match(data?) {
		local i;

		for(i = 1; i <= _rulebook.length; i++) {
			if(checkRule(_rulebook[i], data) == true)
				return(!defaultValue);
		}

		return(defaultValue);
	}
;

// Rulebook whose default state is nil, and becomes true if ALL of its
// rules are true.
// This is the default behavior for the base Rulebook class, so this
// is just a synonym.
class RulebookMatchAll: Rulebook;

// Rulebook that returns true if NONE of its rules match, nil otherwise.
class RulebookMatchNone: Rulebook
	match(data?) {
		local i;

		for(i = 1; i <= _rulebook.length; i++) {
			if(checkRule(_rulebook[i], data) == true)
				return(defaultValue);
		}

		return(!defaultValue);
	}
;
