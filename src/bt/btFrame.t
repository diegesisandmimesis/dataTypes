#charset "us-ascii"
//
// btFrame.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

// Recusive backtracker stack frame type.
// Our generic case is:  we have a list of things we want to assign
// values to and a list of allowed values, where each value can only
// be assigned to one thing.
// Example:  our objects are [ foo, bar, baz] and values are [ 1, 2, 3, 4 ],
//	then we'd try foo = 1, bar = 2, baz = 3;  then foo = 1, bar = 2,
//	baz = 4; then foo = 1, bar = 3, baz = 2;  and so on.
class BTFrame: object
	syslogID = 'BTFrame'

	vList = nil		// list of things we're picking states for
	pList = nil		// the allowed states
	result = nil		// result so far

	construct(v0, v1, v2) {
		vList = v0;
		pList = v1;
		result = (v2 ? v2 : new Vector((vList ? vList.length : 10)));
	}

	// Returns a copy of this frame.
	clone() { return(createInstance(vList, pList, result)); }

	// Returns the next iteration of this frame.
	next() {
		local i, r, v;

		// Make a copy of the result vector.
		r = new Vector(result);

		// If the result vector is shorter than list of objects
		// we're assigning values to, then we just have to pick
		// an unused value and add it to the result vector.
		if(r.length < vList.length) {
			// Iterate over all allowed values.
			for(i = 1; i <= pList.length; i++) {
				// Skip this value if it's used.
				if(r.indexOf(i) != nil)
					continue;

				// Append the value.
				r.append(i);

				// Return a new frame instance with the
				// new result.
				return(createInstance(vList, pList, r));
			}
		}

		// Our results vector is as long as the list of objects
		// we're assigning values to, so we pop the value off
		// the end.
		while((v = r.pop()) != nil) {
			// We try to pick the next allowed value.  If
			// this was already the last one, then we'll
			// never go through the loop (because v + 1
			// is already > pList.length), so we'll
			// fall through.
			for(i = v + 1; i <= pList.length; i++) {
				// Make sure the value is unused.
				if(r.indexOf(i) != nil)
					continue;

				// Append the value and return the new frame.
				r.append(i);
				return(createInstance(vList, pList, r));
			}
			// If we didn't return above, then we'll pop
			// the next value off the end of the result
			// vector and try to do the same thing with it.
			// E.g. if we had foo = 1, bar = 2, baz = 4 and
			// we popped off baz, added one, got 5, tried to
			// iterate through the loop but we only have 4
			// options, so we skip the loop.  Then we
			// pop off the next value, get 2, so we'd
			// next try foo = 1, bar = 3, and continue from
			// there.
		}

		// We popped off the results values until we ran out,
		// which means we're out of permutations, fail.
		return(nil);
	}
;
