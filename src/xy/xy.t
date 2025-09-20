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

class XY: object
	x = nil
	y = nil

	construct(v0, v1) { x = v0; y = v1; }

	// Returns a new XY instance with the same values as this one.
	clone() { return(new XY(x, y)); }

	// Copy the values from the passed argument to ourselves.
	copy(v) {
		if(!isXY(v)) return(nil);
		x = v.x;
		y = v.y;
		return(true);
	}

	// Returns integer approximation of our distance from the origin.
	length() {
		if(!isInteger(x) || !isInteger(y)) return(nil);
		return(sqrtInt((x * x) + (y * y)));
	}

	operator +(x) { return(add(x)); }

	// Returns the sum of ourselves and the passed XY instance.
	add(v) {
		if(!isXY(v)) return(nil);
		return(new XY(x + v.x, y + v.y));
	}

	operator -(x) { return(subtract(x)); }

	// Returns the difference of ourselves and the passed XY instance.
	subtract(v) {
		if(!isXY(v)) return(nil);
		return(new XY(x - v.x, y - v.y));
	}

	operator *(x) { return(multiply(x)); }

	// Scale by the given factor.
	multiply(n) {
		if(!isInteger(n)) return(nil);
		return(new XY(x * n, y * n));
	}

	operator /(x) { return(divide(x)); }

	// Shrink by the given factor.
	divide(n) {
		if(!isInteger(n)) return(nil);
		if(n == 0) return(nil);
		return(new XY(x / n, y / n));
	}

	// Return an integer approximation of the distance between ourselves
	// and the given XY instance.
	distance(v) {
		local v0, v1;

		if(!isXY(v)) return(nil);
		v0 = x - v.x;
		v1 = y - v.y;
		return(sqrtInt((v0 * v0) + (v1 * v1)));
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

	equals(v) {
		if(!isXY(v)) return(nil);
		return((x == v.x) && (y == v.y));
	}

	isAdjacent(v) {
		if(!isXY(v)) return(nil);
		if(equals(v)) return(nil);
		if(abs(x - v.x) > 1) return(nil);
		if(abs(y - v.y) > 1) return(nil);
		return(true);
	}

	isAdjacentToAll(lst) {
		local i;
		if(!isCollection(lst)) return(nil);
		for(i = 1; i <= lst.length; i++)
			if(!isAdjacent(lst[i])) return(nil);
		return(true);
	}

	dot(v) {
		if(!isXY(v)) return(nil);
		return((x * v.x) + (y * v.y));
	}

	toStr() { return('(<<toString(x)>>, <<toString(y)>>)'); }
;

#endif // USE_XY
