#charset "us-ascii"
//
// agrippaSquare.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

// MagicSquare subclass that produces squares using Cornelius Agrippa's
// method.
class AgrippaSquare: MagicSquare
	// Agrippa starts on the cell directly below the center cell.
	firstMagicSquareIndex() {
		return(new _msXY((size[1] / 2) + 1,
			(size[1] / 2) + 2, size[1]));
	}

	// Agrippa's progression schema.
	nextMagicSquareIndex(v) {
		local r;

		// First guess, pick the cell down one and one to the right.
		r = v.clone();
		r.add(1, +1);

		// If the value in our chosen cell is already full, instead
		// pick the cell two below the starting cell.
		if(get(r.x, r.y) != nil) {
			r = v.clone();
			r.add(0, 2);
		}

		// That's our pick.
		return(r);
	}

	// Use Agrippa's method(s) for low-order even squares.
	generateEven() {
		// We don't know how to construct larger squares.
		if(size[1] > 9)
			return;
		if((size[1] / 2) % 2)
			generateSinglyEven();
		else
			generateDoublyEven();
	}

	// Setup common to even squares of both types.
	// This just fills the square starting in the lower left and
	// working across each row left to right and them moving up a row.
	_generateEvenBase() {
		local n, r, sz;

		sz = size[1] * size[2];

		r = new _msXY(1, size[1], size[1]);

		n = 1;
		while(n <= sz) {
			set(r.x, r.y, n);
			r.add(1, 0);
			if(r.x == 1)
				r.add(0, -1);
			n += 1;
		}
	}

	// Flip values on the major diagonals across the center.  E.g.,
	// in the diagram below swap each letter with the same letter in
	// the opposite case:
	//
	// 	a..C
	// 	.bD.
	// 	.dB.
	//	c..A
	//
	_invertEvenDiagonals() {
		local d0, d1, i, j;

		d0 = new Vector();
		d1 = new Vector();
		for(i = 1, j = size[1]; i <= size[1]; i++, j--) {
			d0.append(get(i, i));
			d1.append(get(i, j));
		}
		for(i = 1, j = size[1]; i <= size[1]; i++, j--) {
			set(i, i, d0[d0.length - i + 1]);
			set(i, j, d1[d1.length - i + 1]);
		}

		_invertEvenSecondaryDiagonals();
	}

	// Flip the secondary diagonals like we did the primaries,
	// across the center of the square.
	_invertEvenSecondaryDiagonals() {
		local i, i0, j0, i1, j1, sz, w, v;

		if(size[1] < 8) return;
		sz = size[1];

		// Flip values in the lower left quadrant with the corresponding
		// values in the upper right quadrant.
		w = size[1] / 2;
		for(i = 1; i <= w; i++) {
			i0 = i;
			j0 = i + w;
			v = get(i0, j0);
			i1 = sz - i + 1;
			j1 = w - i + 1;

			set(i0, j0, get(i1, j1));
			set(i1, j1, v);
		}

		// Flip upper left with lower right.
		for(i = 1, j0 = w; i <= w; i++, j0--) {
			i0 = i;
			v = get(i0, j0);
			i1 = sz - i + 1;
			j1 = w + (w - j0 + 1);

			set(i0, j0, get(i1, j1));
			set(i1, j1, v);
		}
	}

	// Agrippa's method for doubly even squares.  That is, squares
	// whose sides are an even multiple of an even multiple of two.
	// Ex: order 4.
	generateDoublyEven() {
		_generateEvenBase();
		_invertEvenDiagonals();
	}

	// Method for singly even squares.  That is, squares whose sides
	// aren't doubly even.  Ex:  order 6.
	generateSinglyEven() {
		_generateEvenBase();
		_invertEvenDiagonals();
		_permuteSaturn();
	}

	// Agrippa's additional permutation of secondary diagonal elements,
	// which appears to be based on the Seal of Saturn.
	_permuteSaturn() {
		local d, i, j, i0, j0, k, p, tmp, w;

		// Dimension of the quadrant we're working with.
		w = size[1] / 2;

		// Iterate over all i and j values for the quadrant.
		for(j = 1; j <= w; j++) {
			// The "real" j value of the cell;  we're working
			// with the lower-left quadrant as the "reference"
			// quadrant.
			j0 = w + j;

			for(i = 1; i <= w; i++) {
				// The "real" i value is the same as the
				// one we're iterating over.
				i0 = i;

				// j value of diagonal at this i.
				d = w - i + 1;

				// If we're on the diagonal, skip.
				if(j == d) continue;

				// Parity of the coordinate sum.
				p = (i + j) % 2;

				// Remember current value.
				tmp = get(i0, j0);

				// Figure out if we're above or below the
				// diagonal.  We use whether we're above
				// or below the line along with the parity
				// of the coordinate sum to figure out
				// whether to swap left to right or up and
				// down.
				// Above the line even and below the line odd
				// swap left to right; above odd and below even
				// swap top to bottom.
				if((j < d) == (p == 0)) {
					// Swap left to right.
					k = w + (w - i + 1);
					set(i0, j0, get(k, j0));
					set(k, j0, tmp);
				} else {
					// Swap top to bottom.
					k = w - j + 1;
					set(i0, j0, get(i0, k));
					set(i0, k, tmp);
				}
			}
		}
	}
;
