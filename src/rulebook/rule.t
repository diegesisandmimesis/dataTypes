#charset "us-ascii"
//
// rule.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataStructures.h"

class RulebookObject: object
	active = true		// active flag
	value = nil		// current value
	defaultValue = nil	// default value

	// Getter/setter for the active flag.
	isActive() { return(active == true); }
	setActive(v?) { active = ((v == true) ? true : nil); }

	// Getter and setter for the value.
	// IMPORTANT:  This is NOT for COMPUTING the current
	//	value--it's just for mechanically storing the value or
	//	retrieving the stored value.
	getValue() { return(value); }
	setValue(v?) {
		v = ((v == true) ? true : nil);

		if(value == v) return(nil);
		value = v;

		return(true);
	}

	// Should we update the value?
	// By default we always do.  This can be overwritten for objects
	// that are only updated in specific situations (e.g., only once
	// per turn).
	updateValue() { return(true); }

	// Evaluate the "real" logic for determining the state and
	// return the value.  This doesn't preserve the value, validate
	// whether or not it should be re-computed, or anything like that.
	// This is just the computation to determine the value.
	match(data?) { return(defaultValue); }
;

class Rule: RulebookObject
	ruleID = nil		// ID for this rule

	rulebook = nil		// rulebook we're in

	construct(id, v?) {
		ruleID = id;
		if(v != nil) defaultValue = v;
	}

	// Evaluate the rule and return its value.
	// Optional argument is the rule type, which should be a subclass
	// of Rule.  If given, rule will only be evaluated if this rule
	// is an instance of the given type.
	eval(type?) {
		// We only evaluate active rules.
		if(!isActive()) return(nil);

		// Check the type, if a type was given.
		if(isRule(type) && !self.ofKind(type)) return(nil);

		// If we're supposed to update the value, do so.
		if(updateValue()) setValue(match());

		// Return the value.
		return(getValue());
	}

	initializeRule() {
		if(isRulebook(rulebook))
			return(rulebook.addRule(self));
		if(isRulebook(location))
			return(location.addRule(self));
		return(nil);
	}
;
