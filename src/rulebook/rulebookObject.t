#charset "us-ascii"
//
// rulebookObject.t
//
//	Base class for rules and rulebooks.
//
//	Lifecycle methods:
//
//		isActive()/setActive(v)
//			Getter and setter for the active property.  If the
//			object isn't active it won't update its value and
//			will by default return its default value
//
//		getValue()/setValue(v)
//			Getter and setter for the object's value.  Note
//			that neither evaluates any of the object's logic,
//			this is just raw bookkeeping
//
//		updateValue()
//			Method that returns boolean true if the value should
//			be updated, nil otherwise.  By default this always
//			just returns true but subclasses use this to
//			juggle things when updates should only occur in
//			specific windows (during action processing, only
//			once per turn, or whatever).  This is something
//			that most instances *probably* won't need to
//			fiddle with directly
//
//		eval()
//			Method that checks to see if the value should be
//			updated and does so.  When in doubt, this is
//			*probably* the entry point most external callers
//			will want unless they know what they're doing
//
//		match()
//			Method that implements the actual logic that
//			determines the current value for the object.  This
//			*probably* shouldn't be called directly, and instead
//			you should use eval(), above, which will call it
//			internally
//
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

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

	// Return value is whether or not we actually evaluated the value,
	// it is NOT the value itself.
	eval(data?) {
		// We only evaluate active rules.
		if(!isActive()) return(nil);

		// If we're not supposed to update right now, don't.
		if(!updateValue()) return(nil);

		// Evaluate and set the value.
		setValue(match(data));

		return(true);
	}

	// Should we update the value?
	// By default we always do.  This can be overwritten for objects
	// that are only updated in specific situations (e.g., only once
	// per turn).
	updateValue() { return(isActive()); }

	// Evaluate the "real" logic for determining the state and
	// return the value.  This doesn't preserve the value, validate
	// whether or not it should be re-computed, or anything like that.
	// This is just the computation to determine the value.
	match(data?) { return(defaultValue); }
;
