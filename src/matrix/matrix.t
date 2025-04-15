#charset "us-ascii"
//
// matrix.t
//
//	Multi-dimensional array datatype.
//
//	Instances must be dimensioned when constructed and at present
//	cannot be resized.  Querying outside the dimensioned bounds will
//	return nil but will not throw an exception.
//
//
// USAGE
//
//	Instances must be dimensioned when constructed.  The cannot be
//	resized after creation.
//
//		// Create a 7x5x3 matrix
//		local m = new Matrix(7, 5, 3);
//
//	Values are stored via Matrix.set().
//
//		// Insert the value "foo" at (5, 3, 1).
//		m.set(5, 3, 1, 'foo');
//
//	Values are retrieved via Matrix.get().
//
//		// Returns 'foo'
//		local v = m.get(5, 3, 1);
//
//	Querying values outside the dimensioned range will return nil.
//	No error will be thrown.
//
//		// Returns nil
//		v = m.get(10, 10, 10);
//
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

class Matrix: object
	_base = nil
	dim = nil

	construct([args]) {
		if((args == nil) || (args.length == 0)) return;

		dim = args.length;

		// Main "wrapper" vector.
		_base = new Vector(args[dim]);

		// Recursively add the "inner" vectors.
		_addDimension(_base, args, dim);
	}

	// Recursively add layers for each dimension.
	_addDimension(ar, lst, idx) {
		local i, v;

		// We don't need to vectors for the "innermost" dimension.
		if(idx <= 1) return;

		for(i = 0; i < lst[idx]; i++) {
			// Vector for this "layer".
			v = new Vector(lst[idx]);

			// Fill it, recursively, with whatever "lower"
			// layers it needs.
			_addDimension(v, lst, idx - 1);

			// Add the new vector to our container.
			ar.append(v);
		}
	}

	// Main setter.
	set([args]) {
		local ar;

		// Make sure the number of args we got is our number of
		// dimensions plus one (for the value being set).
		if(args == nil) return(nil);
		if((_base == nil) || (dim == nil)) return(nil);
		if(args.length != (dim + 1)) return(nil);

		// Fetch the array this value will go into.  The last
		// arg is what tells _fetch() to get the array instead
		// of the value (it's stopping at depth 2, while the
		// value itself is at depth 1).
		if((ar = _fetch(_base, args, args.length - 1, 2)) == nil)
			return(nil);

		// Set the value.
		ar[args[1]] = args[args.length];

		return(true);
	}

	// Recursively fetch.
	// First arg is the current working array.  It will change
	// for each level of recursion (for an x, y, z query it will
	// start out as the main vector, _base, then it'll be
	// _base[foo] for whatever z-value foo we're querying, then
	// it'll be _base[foo][bar], where bar is the y-value, and
	// so on.
	// lst is the array of query args (e.g. [x, y, z]), and idx
	// is the index in that array we're currently processing.
	// It'll start as lst.length and go down as we recurse.
	// The optional depth arg is where we stop recursing.  By
	// default it's 1, which is the "innermost" layer of the
	// array.  That is, if we're a 3-D array, and for example
	// we're querying the value at [2, 3, 5], then ar
	// will start out as _base, lst is (and will always be for
	// this query) [2, 3, 5], and idx will start out as 3.
	// First pass we'll recurse, calling _fetch again
	// with ar now being _base[5] and idx now 2.  That will
	// recurse again with ar as _base[5][3] and idx 1.  And
	// that will return _base[5][3][2], which is the location
	// we're after.
	// If the depth arg was 2, we'd have stopped and when
	// ar was _base[5][3] and returned THAT.  That is, the
	// vector containing the "layer" we're quering.  If we
	// want to do an insert, that's the vector we want to INSERT
	// something at the given coordinates (by setting the
	// second element of it, in this case).
	_fetch(ar, lst, idx, depth?) {
		if((idx < 1) || (idx > lst.length) || (lst[idx] > ar.length))
			return(nil);
		if(idx == (depth ? depth : 1)) return(ar[lst[idx]]);
		return(_fetch(ar[lst[idx]], lst, idx - 1, depth));
	}

	// Queries a value.
	get([args]) {
		if(args == nil) return(nil);
		if((_base == nil) || (dim == nil)) return(nil);
		return(_fetch(_base, args, args.length));
	}
;
