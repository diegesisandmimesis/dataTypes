#charset "us-ascii"
//
// matrix2d.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

class Matrix2D: object
	validator = nil

	rows = (_matrix ? _matrix.length : 0)
	columns = ((_matrix && _matrix.length) ? _matrix[1].length : 0)

	_matrix = nil
	_transpose = nil

	construct(v0, v1?, v2?) {
		if(isInteger(v0) && isInteger(v1))
			createMatrix(v0, v1, v2);
		if(isCollection(v0) && (v1 == nil))
			initMatrix(v0);
	}

	markDirty() {
		_transpose = nil;
	}

	createMatrix(r, c, v?) {
		local i;

		v = (v ? v : 0);

		_matrix = new Vector(r);
		for(i = 0; i < r; i++)
			_matrix.append(new Vector(c).fillValue(v, 1, c));
	}

	initMatrix(v) {
		if(!validate(v))
			return(nil);

		_matrix = new Vector(v.length);
		v.forEach({ x: _matrix.append(new Vector(x)) });
		markDirty();

		return(true);
	}

	validate(v?) {
		v = (v ? v : _matrix);

		// The 2D matrix is an array of arrays, so we make sure
		// we're array-like and have a non-zero length.
		if(!isCollection(v) || !v.length)
			return(nil);

		// Now we make sure each element of the array is also
		// array-like and they're all the same length.
		if(v.valWhich({ x: !isCollection(x)
			|| (x.length != v[1].length) }) != nil) {
			return(nil);
		}

		if((propType(&validator) != TypeNil)
			&& (v.valWhich({ x: !(validator)(x) }) != nil)) {
			return(nil);
		}

		return(true);
	}

	clone() { return(createInstance(_matrix)); }

	// Fill the matrix with a single value.
	fill(v) {
		if(!_matrix) return(nil);

		_matrix.forEach({ x: x.fillValue(v, 1, _matrix[1].length) });
		markDirty();

		return(true);
	}

	multiplyVector(v) {
		local r;

		if(!isVector(v))
			return(nil);

		r = new Vector(v.length);
		_matrix.forEach({ x: r.append(v.dot(x)) });

		return(r);
	}

	unsafeMultiplyVector(v) {
		local r;

		if(!isVector(v))
			return(nil);

		r = new Vector(v.length);
		_matrix.forEach({ x: r.append(v.unsafeDot(x)) });

		return(r);
	}

	transpose() {
		local i, j, r;

		if(isCollection(_transpose))
			return(_transpose);

		r = new Vector(columns);
		for(j = 1; j <= columns; j++) {
			r.append(new Vector(rows));
			for(i = 1; i <= rows; i++)
				r[r.length].append(_matrix[i][j]);
		}

		_transpose = r;

		return(r);
	}

	_validateCoord(i, j) {
		if(!isInteger(i) || !isInteger(j)) return(nil);
		if((i < 1) || (i > rows)) return(nil);
		if((j < 1) || (j > columns)) return(nil);
		return(true);
	}

	get(i, j) {
		if(!_validateCoord(i, j)) return(nil);
		return(_matrix ? _matrix[i][j] : nil);
	}

	set(i, j, v) {
		if(!_matrix) return(nil);
		if(!_validateCoord(i, j)) return(nil);
		_matrix[i][j] = v;
		markDirty();
		return(true);
	}

	equals(m) {
		local i, j;

		if(!isMatrix2D(m))
			return(nil);
		if((m.rows != rows) || (m.columns != columns))
			return(nil);

		for(j = 1; j <= rows; j++) {
			for(i = 1; i <= columns; i++) {
				if(m.get(i, j) != get(i, j))
					return(nil);
			}
		}

		return(true);
	}
;
