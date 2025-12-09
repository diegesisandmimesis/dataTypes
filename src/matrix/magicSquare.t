#charset "us-ascii"
//
// magicSquare.t
//
//	Provides a magic square class.  Currently only generates magic squares
//	with odd orders.
//
//
// USAGE
//
//	// Create a magic square of order 3.
//	local sq = new MagicSquare(3);
//
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

// Helper class for magic square generation.
class _msXY: object
	x = nil
	y = nil
	n = nil		// max value

	construct(v0, v1, v2) { x = v0; y = v1; n = v2; }

	add(v0, v1) {
		// Verify args.
		if(!isInteger(v0)) v0 = 0;
		if(!isInteger(v1)) v1 = 0;

		// Add.
		x += v0;
		y += v1;

		// Bounds check.
		while(x < 1) x += n;
		while(x > n) x -= n;
		while(y < 1) y += n;
		while(y > n) y -= n;
	}

	// Return a copy of this object.
	clone() { return(new _msXY(self.x, self.y, self.n)); }
;

// Magic square class.
class MagicSquare: IntegerMatrix
	construct(n) {
		inherited(n, n);
		generate();
	}

	generate() {
		if(size[1] % 2)
			generateOdd();
		else
			generateEven();
	}

	// Not implemented
	generateEven() {}

	// Generate an odd-order magic square using Loubère's method.
	generateOdd() {
		local n, r, sz;

		// Total number of squares to fill
		sz = size[1] * size[2];

		// First we're placing the one.
		n = 1;

		// Start out in the middle of the top row.
		r = new _msXY((size[1] / 2) + 1, 1, size[1]);

		// Iterate over all the values.
		while(n <= sz) {
			set(r.x, r.y, n);
			r = nextMagicSquareIndex(r);
			n += 1;
		}
	}

	// Given a current index, return the next cell to fill.
	nextMagicSquareIndex(v) {
		local r;

		// First guess, pick the cell up one and one to the right.
		r = v.clone();
		r.add(1, -1);

		// If the value in our chosen cell is already full, instead
		// pick the cell below the starting cell.
		if(get(r.x, r.y) != nil) {
			r = v.clone();
			r.add(0, 1);
		}

		// That's our pick.
		return(r);
	}

	// Get the magic sum for this square.
	getMagicSum() {
		local i, r;

		r = 0;
		for(i = 1; i <= size[1]; i++)
			r += get(i, 1);

		return(r);
	}

	// Make sure we have a valid magic square.
	// Returns boolean true on success, nil otherwise.
	validate() {
		local chk, i, j, v;

		// Get the magic sum.  This will be computed by summing the
		// top row.
		v = getMagicSum();

		// Check the rows.
		for(j = 1; j <= size[2]; j++) {
			chk = 0;
			for(i = 1; i <= size[1]; i++) {
				chk += get(i, j);
			}
			if(chk != v)
				return(nil);
		}

		// Check the columns.
		for(j = 1; j <= size[2]; j++) {
			chk = 0;
			for(i = 1; i <= size[1]; i++) {
				chk += get(j, i);
			}
			if(chk != v)
				return(nil);
		}

		return(true);
	}
;
