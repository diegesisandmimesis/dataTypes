#charset "us-ascii"
//
// magicSquareOdd.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

modify MagicSquare
	// Generate an odd-order magic square using Loubère's method.
	generateOdd() {
		local n, r, sz;

		// Total number of squares to fill
		sz = size[1] * size[2];

		// First we're placing the one.
		n = 1;

		// Start out in the middle of the top row.
		//r = new _msXY((size[1] / 2) + 1, 1, size[1]);
		r = firstMagicSquareIndex();

		// Iterate over all the values.
		while(n <= sz) {
			set(r.x, r.y, n);
			r = nextMagicSquareIndex(r);
			n += 1;
		}
	}

	// Returns an _msXY instance giving the location of the cell
	// to start with.
	firstMagicSquareIndex() {
		return(new _msXY((size[1] / 2) + 1, 1, size[1]));
	}

	// Given a current cell, return the next cell to fill.
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
;
