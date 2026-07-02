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

	defaultValue = 0

	rows = 0
	columns = 0

	// Matrix in row-first, vector-of-vectors format.
	_matrix = nil

	// Matrix transpose.
	_transpose = nil

	construct(v0, v1?, v2?) {
		if(isInteger(v0) && isInteger(v1))
			createMatrix(v0, v1, v2);
		if(isCollection(v0) && (v1 == nil))
			initMatrix(v0);
	}

	// Wraps an matrix around an existing vector-of-vectors.  Relies
	// on the caller to validate the argument.
	// This is mostly done as a performance tweak for the various
	// arithmatic methods that construct known-valid vector-of-vector
	// matrix definitions (the thing that will live in _matrix in
	// an instance), so going through the constructor would just
	// be burning cycles creating a new copy of the valid new data.
	_wrap(v) {
		local r;

		r = createInstanceOfSelf();
		r._matrix = v;
		r._setDimensions();

		return(r);
	}

	_setDimensions() {
		rows = (_matrix ? _matrix.length : 0);
		columns = ((_matrix && _matrix.length) ? _matrix[1].length : 0);
	}

	markDirty() {
		_transpose = nil;
	}

	createMatrix(r, c, v?) {
		local i;

		v = (v ? v : defaultValue);

		_matrix = new Vector(r);
		for(i = 0; i < r; i++)
			_matrix.append(new Vector(c).fillValue(v, 1, c));
		_setDimensions();
	}

	initMatrix(v) {
		if(!validate(v))
			return(nil);

		_matrix = new Vector(v.length);
		v.forEach({ x: _matrix.append(new Vector(x)) });
		markDirty();
		_setDimensions();

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

	clone() { return(createInstanceOfSelf(_matrix)); }

	// Fill the matrix with a single value.
	fill(v) {
		if(!_matrix) return(nil);

		_matrix.forEach({ x: x.fillValue(v, 1, _matrix[1].length) });
		markDirty();

		return(true);
	}

	multiply(m) {
		local i, j, n, nrows, r, row0, row1, row;

		if(!isMatrix2D(m) || columns != m.rows)
			return(nil);

		n = m.columns;
		m = m.transpose();

		nrows = rows;
		r = new Vector(nrows);
		for(i = 1; i <= nrows; i++) {
			row0 = unsafeGetRow(i);
			row = new Vector(n);
			for(j = 1; j <= n; j++) {
				//row1 = m[j];
				row1 = m.unsafeGetRow(j);
				row.append(row0.dot(row1));
			}
			r.append(row);
		}

		return(_wrap(r));
	}

	multiplyScalar(v) {
		local r;

		if(!isInteger(v))
			return(nil);

		r = new Vector(rows);
		_matrix.forEach({ x: r.append(x.mapAll({ y: y * v })) });

		return(_wrap(r));
	}

	mapAll(fn) {
		local r;

		if(!isFunction(fn))
			return(nil);

		r = new Vector(rows);
		_matrix.forEach({ x: r.append(x.mapAll({ y: (fn)(y) })) });

		return(_wrap(r));
	}

	multiplyVector(v) {
		local r;

		r = new Vector(v.length);
		_matrix.forEach({ x: r.append(v.dot(x)) });

		return(r);
	}

	/*
	unsafeMultiplyVector(v) {
		local r;

		if(!isVector(v))
			return(nil);

		r = new Vector(v.length);
		_matrix.forEach({ x: r.append(v.dot(x)) });

		return(r);
	}
	*/

	transpose() {
		local i, j, nColumns, nRows, r, v;

		if(isMatrix2D(_transpose))
			return(_transpose);

		nColumns = columns;
		nRows = rows;

		r = new Vector(nColumns);
		for(j = 1; j <= nColumns; j++) {
			v = new Vector(nRows);
			for(i = 1; i <= nRows; i++)
				v.append(_matrix[i][j]);
			r.append(v);
		}

		_transpose = _wrap(r);

		return(_transpose);
	}

	_validateCoord(i, j) {
		if(!isInteger(i) || !isInteger(j)) return(nil);
		if((i < 1) || (i > rows)) return(nil);
		if((j < 1) || (j > columns)) return(nil);
		return(true);
	}

	getRow(i) {
		if(!isInteger(i) || (i < 1) || (i > rows)) return(nil);
		return(_matrix ? _matrix[i] : nil);
	}

	unsafeGetRow(i) {
		return(_matrix ? _matrix[i] : nil);
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

	insert(i, j, v) { set(i, j, v); }
	query(i, j) { return(get(i, j)); }

	equals(m) {
		local i, j, nColumns, nRows, r0, r1;

		if(!isMatrix2D(m))
			return(nil);
		if((m.rows != rows) || (m.columns != columns))
			return(nil);

		nColumns = columns;
		nRows = rows;
		for(j = 1; j <= nRows; j++) {
			r0 = getRow(j);
			r1 = m.getRow(j);
			for(i = 1; i <= nColumns; i++) {
				if(r0[i] != r1[i])
					return(nil);
			}
		}

		return(true);
	}

	_addSubtract(m, subt?) {
		local i, j, l, nColumns, nRows, r0, r1, r;

		if(!isMatrix2D(m))
			return(nil);
		if((m.rows != rows) || (m.columns != columns))
			return(nil);

		nRows = rows;
		nColumns = columns;

		l = new Vector(nRows);
		for(j = 1; j <= nRows; j++) {
			r0 = getRow(j);
			r1 = m.getRow(j);
			r = new Vector(nColumns);
			for(i = 1; i <= nColumns; i++) {
				if(subt)
					r.append(r0[i] - r1[i]);
				else
					r.append(r0[i] + r1[i]);
			}
			l.append(r);
		}

		return(_wrap(l));
	}

	add(m) { return(_addSubtract(m)); }
	subtract(m) { return(_addSubtract(m, true)); }

	frobeniusNorm() {
		local d;

		d = 0;
		mapAll({ x: d += (x * x) });
		return(Matrix._sqrtInt(d));
	}

	frobeniusDistance(m) {
		local d;

		if((d = subtract(m)) == nil)
			return(nil);

		return(d.frobeniusNorm());
	}

	maxFrobeniusDistance(v?) {
		if(v == nil) {
			v = 0;
			mapAll(function(x) {
				if(abs(x) > v)
					v = abs(x);
			});
		}
		return(Matrix._sqrtInt(rows * columns * v * v));
	}

	maxAbs() {
		return(_matrix ? _matrix.mapAll({ x: x.maxAbs() }).maxVal()
			: nil);
	}

	log() {
		if(!_matrix) "\nno matrix\n ";
		_matrix.forEach({ x: "\n[ <<x.join(', ')>> ]\n " });
	}

	forEach(fn) { return(_matrix.forEach(fn)); }
;
