#charset "us-ascii"
//
// magicSquare.t
//
//	Provides a magic square class.
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
// Used when computing odd-order squares via the Siamese method.  Handles
// wrapping around edges of the matrix.
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

// Enum values for the magic square genres.
enum oddMagicSquare, singlyEvenMagicSquare, doublyEvenMagicSquare;

// Magic square class.
class MagicSquare: IntegerMatrix
	_magicSquareType = nil

	construct(n) {
		inherited(n, n);
		generate();
	}

	getMagicSquareOrder() { return(size[1]); }

	// Returns the enum value for this magic square's genre.
	getMagicSquareType() {
		if(_magicSquareType == nil)
			_magicSquareType = computeMagicSquareType();
		return(_magicSquareType);
	}

	// Compute and return the genre of the square:  odd, singly-even,
	// or doubly-even.
	computeMagicSquareType() {
		if(size[1] % 2)
			return(oddMagicSquare);
		if((size[1] / 2) % 2)
			return(singlyEvenMagicSquare);
		return(doublyEvenMagicSquare);
	}

	// Generate the square.
	generate() {
		// Trivial case of square of order 1:  a 1x1 matrix
		// containing the value 1.
		if(size[1] == 1) {
			set(1, 1, 1);
			return;
		}

		// There is no magic square of order 2.
		if(size[1] == 2)
			return;

		// Punt to the appropriate generation method.
		switch(getMagicSquareType()) {
			case oddMagicSquare:
				generateOdd();
				break;
			case singlyEvenMagicSquare:
				generateSinglyEven();
				break;
			case doublyEvenMagicSquare:
				generateDoublyEven();
				break;
		}
	}

	// Fill the matrix with sequential values.  Doesn't generate a magic
	// square, but is used by some generation methods as a preliminary
	// step.
	fillMagicSquare() {
		local i, j, n, v;

		n = size[1];
		v = 1;
		for(j = 1; j <= n; j++) {
			for(i = 1; i <= n; i++) {
				set(i, j, v);
				v += 1;
			}
		}
	}

	// Get the magic sum for this square.
	getMagicSum() {
		local i, r, v;

		r = 0;
		for(i = 1; i <= size[1]; i++) {
			if(!isInteger(v = get(i, 1)))
				return(nil);
			r += v;
		}

		return(r);
	}

	// Make sure we have a valid magic square.
	// Returns boolean true on success, nil otherwise.
	validate() {
		local chk, i, j, v;

		// Get the magic sum.  This will be computed by summing the
		// top row.
		v = getMagicSum();
		if(!isInteger(v))
			return(nil);

		// Check the rows.
		for(j = 1; j <= size[2]; j++) {
			chk = 0;
			for(i = 1; i <= size[1]; i++) {
				chk += get(i, j);
			}
			if(chk != v) {
				return(nil);
			}
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

		chk = 0;
		for(j = 1; j <= size[2]; j++) {
			chk += get(j, j);
		}
		if(chk != v)
			return(nil);

		chk = 0;
		i = size[2];
		for(j = 1; j <= size[2]; j++) {
			chk += get(i, j);
			i -= 1;
		}
		if(chk != v)
			return(nil);


		return(true);
	}
;
