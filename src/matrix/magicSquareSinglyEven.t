#charset "us-ascii"
//
// conwaySquareSinglyEven.t
//
//	Generate singly-even magic squares (order 6, 10, 14, and so on)
//	using Conway's LUX method.
//
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

modify MagicSquare
	generateSinglyEven() {
		local i, m, n, s, sz, v;

		n = (size[1] - 2) / 4;

		// Number of cells.
		sz = size[1] * size[2];

		// Build the LUX square.
		m = _buildLUXSquare(n);

		// Start in the top center of the LUX square and
		// proceed via Siamese progression.
		s = (2 * n) + 1;
		v = new _msXY((s / 2) + 1, 1, s);

		i = 1;
		while(i < sz) {
			_setLUX(i, m.get(v.x, v.y), v.x, v.y);
			v = _nextLUX(v);
			i += 4;
		}
	}

	// Siamese rule implemented for our LUX square.
	_nextLUX(v) {
		local r;

		r = v.clone();
		r.add(1, -1);

		// We have to translate the LUX coordinates to our
		// coordinates to check if we've visited this cell already.
		if(get((r.x - 1) * 2 + 1, (r.y - 1) * 2 + 1) != nil) {
			r = v.clone();
			r.add(0, 1);
		}

		return(r);
	}

	// Populate the "real" square cells for a single LUX cell.  Each
	// LUX cell corresponds to a 2x2 block in the "real" square.
	_setLUX(n, lv, x, y) {
		// Translate the LUX coordinates to our coordinates.
		x = (x - 1) * 2 + 1;
		y = (y - 1) * 2 + 1;

		// Each value of LUX corresponds to a pattern for filling
		// four consecutive values into a 2x2 group of cells.
		switch(lv) {
			case 'L':
				set(x + 1, y, n);
				set(x, y + 1, n + 1);
				set(x + 1, y + 1, n + 2);
				set(x, y, n + 3);
				break;
			case 'U':
				set(x, y, n);
				set(x, y + 1, n + 1);
				set(x + 1, y + 1, n + 2);
				set(x + 1, y, n + 3);
				break;
			case 'X':
				set(x, y, n);
				set(x + 1, y + 1, n + 1);
				set(x, y + 1, n + 2);
				set(x + 1, y, n + 3);
				break;
		}
	}

	// Make the LUX square.
	_buildLUXSquare(n) {
		local i, j, m, s;

		// Size is 2n + 1
		s = (2 * n) + 1;
		m = new Matrix(s, s);

		// Fill the top n + 1 rows with "L".
		for(j = 1; j <= n + 1; j++) {
			for(i = 1; i <= s; i++) {
				m.set(i, j, 'L');
			}
		}

		// Fill the next row with "U".
		for(i = 1; i <= s; i++) {
			m.set(i, n + 2, 'U');
		}

		// Fill the remaining rows with "X".
		for(j = 1; j <= n - 1; j++) {
			for(i = 1; i <= s; i++) {
				m.set(i, j + n + 2, 'X');
			}
		}

		// Swap the center "L" with the "U" below it.
		m.set((s / 2) + 1, (s / 2) + 1, 'U');
		m.set((s / 2) + 1, (s / 2) + 2, 'L');

		// Done.
		return(m);
	}
;
