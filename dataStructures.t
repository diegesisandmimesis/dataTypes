#charset "us-ascii"
//
// dataStructures.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataStructures.h"

// Module ID for the library
dataStructuresModuleID: ModuleID {
        name = 'Data Structures Library'
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

// Generate permutations using Heap's algorithm.
// Argument is the array of things to permute.  Must consist of 8 or
// fewer items;  more will return nil (instead of generating a runtime
// error as the VM explodes).
function permutations(lst) {
	local r;

	// Sanity check the argument.
	if(!lst.ofKind(Collection) || (lst.length > 8)) return(nil);

	// For the return value.
	r = new Vector();

	// Call the "private" method.
	_heapPermute(r, lst.length, new Vector(lst));

	return(r);
}

// "Private" function used by the above.  This is the actual recursive Heap
// algorithm.
function _heapPermute(r, n, lst) {
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
