#charset "us-ascii"
//
// dataTypes.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

// Module ID for the library
dataTypesModuleID: ModuleID {
        name = 'Data Types Library'
        byline = 'Diegesis & Mimesis'
        version = '1.0'
        listingOrder = 99
}

// Extension to the builtin Vector class.
modify Vector
	// Swap the ith and jth elements.
	swap(i, j) {
		local tmp;

		tmp = self[j];
		self[j] = self[i];
		self[i] = tmp;
	}
;

modify Collection
	// Generate permutations using Heap's algorithm.
	// Collection must contain 8 or fewer items; more will
	// return (instead of generating a runtime error as the
	// VM explodes).
	permutations() {
		local r;

		// Sanity check the argument.
		if(length() > 8) return(nil);

		// For the return value.
		r = new Vector();

		// Call the "private" method.
		_heapPermute(r, length(), new Vector(self));

		return(r);
	}

	// "Private" function used by the above.  This is the recursive
	// Heap algorithm.
	_heapPermute(r, n, lst) {
		local i;

		if(n == 1) {
			r.append(new Vector(lst));
			return;
		}

		for(i = 1; i <= n; i++) {
			_heapPermute(r, n - 1, lst);
			if(n % 2)
				lst.swap(1, n);
			else
				lst.swap(i, n);
		}
	}
;

modify TadsObject
	// Copy all the properties directly defined on the argument onto
	// this object, if the corresponding property is defined (at all,
	// not necessarily directly) on it.
	// So given:
	//
	//	obj0: object { foo = 1 bar = 2 }
	//	obj1: object { foo = nil }
	//
	// Then obj1.copyProps(obj0) will produce:
	//
	//	obj1: object { foo = 1 }
	//
	// Or alternately (without the first copyProps() call above),
	// obj0.copyProps(obj1) will produce:
	//
	//	obj0: object { foo = nil bar = 2 }
	//
	copyProps(cfg) {
		if(cfg == nil) cfg = object {};
		cfg.getPropList().forEach(function(o) {
			if(!cfg.propDefined(o, PropDefDirectly)) return;
			if(!self.propDefined(o)) return;
			self.(o) = cfg.(o);
		});
	}
;
