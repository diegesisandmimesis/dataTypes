#charset "us-ascii"
//
// magicSquareDoublyEven.t
//
//	Generate doubly-even magic squares (orders 4, 8, 12, and so on).
//
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

modify MagicSquare
	generateDoublyEven() {
		local i, j, n, n1, n3, sq;

		// Fill the square sequentially.
		fillMagicSquare();

		n = size[1];			// order of square
		sq = (n * n) + 1;		// constant for this square
		n1 = n / 4;			// first 1/4 of square
		n3 = n1 * 3;			// last quarter of square

		// Upper right.
		for(j = 1; j <= n1; j++) {
			for(i = 1; i <= n1; i++) {
				set(i, j, sq - get(i, j));
			}
		}

		// Lower right.
		for(j = n3 + 1; j <= n; j++) {
			for(i = 1; i <= n1; i++) {
				set(i, j, sq - get(i, j));
			}
		}

		// Upper left.
		for(j = 1; j <= n1; j++) {
			for(i = n3 + 1; i <= n; i++) {
				set(i, j, sq - get(i, j));
			}
		}

		// Lower left.
		for(j = n3 + 1; j <= n; j++) {
			for(i = n3 + 1; i <= n; i++) {
				set(i, j, sq - get(i, j));
			}
		}

		// Center.
		for(j = n1 + 1; j <= n3; j++) {
			for(i = n1 + 1; i <= n3; i++) {
				set(i, j, sq - get(i, j));
			}
		}
	}
;
