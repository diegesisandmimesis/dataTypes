#charset "us-ascii"
//
// rulebook.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataStructures.h"

#ifdef RULEBOOK

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

	eval(type?) {
		if(!isActive()) return(nil);
		if(isRulebook(type) && !self.ofKind(type)) return(nil);
		if(updateValue()) setValue(match());
		return(getValue());
	}

	initializeRulebook() {}

	match(data?) {
		local i;

		for(i = 1; i <= _rulebook.length; i++) {
			if(_rulebook[i].eval(Rule) != true)
				return(defaultValue);
		}

		return(!defaultValue);
	}
;

// Rulebook whose default value is nil, and becomes true if ANY of its
// rules are true.
class RulebookMatchAny: Rulebook
	defaultValue = nil

	match(data?) {
		local i;

		for(i = 1; i <= _rulebook.length; i++) {
			if(_rulebook[i].eval(Rule) == true)
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

class RulebookMatchNone: Rulebook
	match(data?) {
		local i;

		for(i = 1; i <= _rulebook.length; i++) {
			if(_rulebook[i].eval(Rule) == true)
				return(defaultValue);
		}

		return(!defaultValue);
	}
;

#endif // RULEBOOK
