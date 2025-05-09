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
	size = nil

	construct([args]) {
		if((args == nil) || (args.length == 0)) return;

		dim = args.length;

		// Main "wrapper" vector.
		_base = new Vector(args[dim]);

		size = args.sublist(1, args.length);

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

	free() {
		if(_base == nil) return;
		_free(_base);
		_base = nil;
		dim = nil;
		size = nil;
	}

	_free(ar) {
		if(!isVector(ar) || (ar.length < 1))
			return;
		ar.forEach({ x: _free(x) });
		ar.setLength(0);
	}

	// Loads the contents of the matrix from the given array,
	// which must be a linearized 2-dimensional square matrix.
	// That is, it must be a 2x2 matrix stored as a 4-element List,
	// a 3x3 matrix as a 9-element list, and so on.
	// The order of elements is:
	//	a, b
	//	c, d
	// So to load the matrix:
	//	3, 5
	//	7, 11
	// ...you'd use foo.load([ 3, 5, 7, 11 ]), where foo is a
	// IntegerMatrix instance.
	load(ar) {
		local i, j, s;

		if(!isCollection(ar)) return(nil);
		s = _sqrtInt(ar.length);
		if(ar.length != (s * s)) return(nil);

		dim = 2;
		size = [ s, s ];

		_base = new Vector(s);
		_addDimension(_base, size, dim);

		i = 1;
		j = 1;
		ar.forEach(function(v) {
			set(i, j, v);
			i += 1;
			if(i > s) {
				i = 1;
				j += 1;
			}
		});

		return(true);
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

		if(args[1] < 1)
			return(nil);

		// Set the value.
		ar[args[1]] = args[args.length];

		return(true);
	}

	// Wrapper methods for a slightly more consistent API.
	insert([args]) { return(set(args...)); }
	query([args]) { return(get(args...)); }

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
		if((idx < 1) || (idx > lst.length)
			|| (lst[idx] < 1) || (lst[idx] > ar.length))
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

	// Sets every element of the array to be equal to v.
	fill(v) {
		if(_base == nil)
			return(nil);

		_fill(_base, v, size.length);

		return(true);
	}

	_fill(ar, v, idx) {
		if(!isVector(ar)) return;
		if(idx == 1)
			ar.fillValue(v, 1, size[1]);
		else
			ar.forEach({ x: _fill(x, v, idx - 1) });
	}

	// Returns this matrix's transpose.
	transpose() {
		local i, j, r;

		if(dim != 2) return(nil);
		r = createInstance(size[2], size[1]);
		for(j = 1; j <= size[2]; j++)
			for(i = 1; i <= size[1]; i++)
				r.set(j, i, get(i, j));
		return(r);
	}

	// Stub debugging method.
	debugMatrix() {}
;

class IntegerMatrix: Matrix
	// Only accept integer values.
	set([args]) {
		if((args != nil) && isCollection(args)
			&& !isInteger(args[args.length])) {
			return(nil);
		}
		return(inherited(args...));
	}

	// Returns the determinant.  Only works for 2-dimensional
	// square matrices.
	determinant() {
		if(dim != 2) return(nil);

		// Make sure we're square.
		if(size.valWhich({ x: x != size[1] }) != nil) return(nil);

		// If we're a 1x1 matrix our determinant is just our value.
		if(size[1] == 1)
			return(get(1, 1));

		// Handle 2x2 matrices as a special case.
		if(size[1] == 2)
			return(_determinant2x2());

		// Recursively compute the determinant for any other
		// size.
		return(_determinant());
	}

	// Determinant of a 2x2 matrix.
	_determinant2x2() {
		return((get(1, 1) * get(2, 2)) - (get(2, 1) * get(1, 2)));
	}

/*
	_determinant3x3() {
		return(
			(get(1, 1) *
				((get(2, 2) * get(3, 3))
					- (get(3, 2) * get(2, 3))))
			- (get(2, 1) *
				((get(1, 2) * get(3, 3))
					- (get(1, 3) * get(3, 1))))
			+ (get(3, 1) *
				((get(1, 2) * get(2, 3))
					- (get(2, 2) * get(1, 3))))
		);
	}
*/

	// Compute the determinant recursively.
	_determinant() {
		local i, m, n, r;

		n = size[1];

		r = 0;

		// Iterate over our columns.
		for(i = 1; i <= n; i++) {
			// Get the sub-matrix for this step.
			m = _submatrix(i);

			// Add its contribution.
			r += ((i % 2) ? 1 : -1) * get(i, 1) * m.determinant();
		}

		return(r);
	}

	// Return the nth smaller matrix used in computing the determinant.
	_submatrix(n) {
		local c, i, j, m, v;

		// Create a square matrix one row and column smaller
		// than this one.
		m = createInstance(size[1] - 1, size[1] - 1);

		// Iterate over every row but the top one.
		for(j = 2; j <= size[1]; j++) {
			// Counter for the column in the computed matrix.
			c = 1;

			// Iterate over every column except our arg.
			for(i = 1; i <= size[1]; i++) {
				if(i == n) continue;

				if((v = get(i, j)) == nil)
					v = 0;

				// Assign the value
				m.set(c, j - 1, v);

				// Advance our column number.
				c += 1;
			}
		}

		return(m);
	}
;

// Subclass of Matrix which indexes from zero instead of one.
// That is, the first element is of a two-dimensional matrix is
// retrieved by Matrix0.get(0, 0) instead of .get(1, 1).
class Matrix0: Matrix
	get([args]) {
		local v;

		if((args == nil) || !isCollection(args))
			return(nil);
		v = new Vector(args.length);
		args.forEach({ x: v.append(x + 1) });

		return(inherited(v...));
	}

	set([args]) {
		local i, v;

		if((args == nil) || !isCollection(args))
			return(nil);
		v = new Vector(args.length);
		for(i = 1; i < args.length; i++)
			v.append(args[i] + 1);
		v.append(args[args.length]);
		return(inherited(v...));
	}
;

#ifdef _PATCH_SQRT_INT

// If we're being compiled without the intMath module, define the
// sqrtInt() function it provides as a method on IntegerMatrix.  That's
// all Matrix needs from the module, and IntegerMatrix is the only thing
// that needs it.
modify IntegerMatrix
	// Arcane.  For an explanation see the comments in the intMath
	// module.
	_sqrtInt(v) {
		local c, r, shift;

		shift = 32;
		shift += shift & 1;
		r = 0;
		while(shift > 0) {
			shift -= 2;
			r <<= 1;
			c = r + 1;
			if((c * c) <= (v >> shift))
				r = c;
		}
		return(r);
	}
;

#else

modify IntegerMatrix
	_sqrtInt(v) { return(sqrtInt(v)); }
;

#endif /// _PATCH_SQRT_INT


#ifdef __DEBUG

modify Matrix
	debugMatrix() {
		local i, j;

		if(dim != 2) return;
		"\nmatrix:\n ";
		for(j = 1; j <= size[2]; j++) {
			"\n ";
			for(i = 1; i <= size[1]; i++) {
				"\t<<toString(get(i, j))>> ";
			}
			"\n ";
		}
	}
;

#endif // __DEBUG
