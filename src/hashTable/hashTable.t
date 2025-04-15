#charset "us-ascii"
//
// hashTable.t
//
//	Simple hash table-ish implementation.
//
//	Not technically a "real" hash table, just an associative array
//	that handles collisions by stuffing them in an array.
//
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

class HashTable: object
	_table = perInstance(new LookupTable())

	_getArray(id) { return(_table[id]); }
	_initArray(id) { return( _table[id] = new Vector()); }

	// Insert the value v with key ID.
	insert(id, v) {
		local ar;

		if((ar = _getArray(id)) == nil)
			ar = _initArray(id);

		ar.append(v);

		return(true);
	}

	// Return the value associated with key ID.  If the second
	// argument is a callback function it will be used as a check
	// function for each element of the return value, and only
	// elements for which the callback returns boolean true when
	// called with the element as its argument will be included.
	query(id, cb?) {
		local ar;

		if((ar = _getArray(id)) == nil)
			return(nil);
		if(!isFunction(cb))
			return(ar);

		return(ar.subset({ x: ((cb)(x) == true) }));
	}
;
