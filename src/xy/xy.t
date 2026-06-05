#charset "us-ascii"
//
// xy.t
//
//	Datatype for holding x-y coordinates.
//
// USAGE
//
//	// Creates a XY instance with the coordinates (5, 3).
//	local v = new XY(5, 3);
//
//
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

#ifdef USE_XY

// Base XY class.  This class expects callers to handle validation of
// all arguments themselves.  Specifically so callers with tight pipelines
// can use _XY instead of XY if they can do type validation once instead
// of on every operation.
class _XY: object
	x = nil
	y = nil

	construct(v0, v1) { x = v0; y = v1; }

	// Returns a new XY instance with the same values as this one.
	clone() { return(createInstance(x, y)); }

	// Copy the values from the passed argument to ourselves.
	copy(v) {
		x = v.x;
		y = v.y;
		return(true);
	}

	// Returns integer approximation of our distance from the origin.
	length() {
		return(Matrix._sqrtInt((x * x) + (y * y)));
	}

	// Returns the sum of ourselves and the passed XY instance.
	add(v) { return(createInstance(x + v.x, y + v.y)); }
	operator +(x) { return(add(x)); }
	iadd(v) { x += v.x; y += v.y; return(self); }

	// Returns the difference of ourselves and the passed XY instance.
	subtract(v) { return(createInstance(x - v.x, y - v.y)); }
	operator -(x) { return(subtract(x)); }
	isubtract(v) { x -= v.x; y -= v.y; return(self); }

	// Scale by the given factor.
	multiply(n) { return(createInstance(x * n, y * n)); }
	operator *(x) { return(multiply(x)); }
	imultiply(n) { x *= n; y *= n; return(self); }

	// Shrink by the given factor.
	divide(n) {
		if(n == 0) return(nil);
		return(createInstance(x / n, y / n));
	}
	operator /(x) { return(divide(x)); }

	idivide(n) { if(n == 0) return(nil); x /= n; y /= n; return(self); }

	// Return an integer approximation of the distance between ourselves
	// and the given XY instance.
	distance(v) {
		local v0, v1;

		v0 = x - v.x;
		v1 = y - v.y;

		return(Matrix._sqrtInt((v0 * v0) + (v1 * v1)));
	}

	// Treat the XY coords as a vector (from the origin) and
	// "normalize" it, reducing it to a vector whose elements
	// are all 0 or +/-1.
	// This is mostly used to translate an integer vector into a
	// a Moore neighbor (the Moore neighborhood on a square grid
	// is one where "neighbors" include diagonals).
	normalize() {
		local v;

		// Scale our vector by 10 and then divide by the 1/10th the
		// length.  This will result in both coords being in [0, 10],
		// with (7, 7) being 
		v = multiply(10);
		v = v.divide(v.length() / 10);

		return(v);
	}

	equals(v) { return((x == v.x) && (y == v.y)); }

	isAdjacent(v) {
		if(equals(v)) return(nil);
		if(abs(x - v.x) > 1) return(nil);
		if(abs(y - v.y) > 1) return(nil);
		return(true);
	}

	isAdjacentToAll(lst) {
		local i;
		for(i = 1; i <= lst.length; i++)
			if(!isAdjacent(lst[i])) return(nil);
		return(true);
	}

	dot(v) { return((x * v.x) + (y * v.y)); }

	toStr() { return('(<<toString(x)>>, <<toString(y)>>)'); }
;

// Version of the XY logic with safety checks on the arguments.
class XY: _XY
	copy(v) {
		if(!isXY(v)) return(nil);
		return(inherited(v));
	}
	length() {
		if(!isInteger(x) || !isInteger(y)) return(nil);
		return(inherited());
	}
	add(v) {
		if(!isXY(v)) return(nil);
		return(inherited(v));
	}
	subtract(v) {
		if(!isXY(v)) return(nil);
		return(inherited(v));
	}
	multiply(n) {
		if(!isInteger(n)) return(nil);
		return(inherited(n));
	}
	divide(n) {
		if(!isInteger(n)) return(nil);
		return(inherited(n));
	}
	distance(v) {
		if(!isXY(v)) return(nil);
		return(inherited(v));
	}
	equals(v) {
		if(!isXY(v)) return(nil);
		return(inherited(v));
	}
	isAdjacent(v) {
		if(!isXY(v)) return(nil);
		return(inherited(v));
	}
	isAdjacentToAll(lst) {
		if(!isCollection(lst)) return(nil);
		return(inherited(lst));
	}
	dot(v) {
		if(!isXY(v)) return(nil);
		return(inherited(v));
	}
;

#endif // USE_XY
