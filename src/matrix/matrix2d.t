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
	matrix = nil

	// Matrix transpose.
	_transpose = nil

	construct(v0, v1?, v2?) {
		if(isInteger(v0) && isInteger(v1))
			createMatrix(v0, v1, v2);
		else if(isCollection(v0) && (v1 == nil))
			loadMatrix(v0);
		else
			touchMatrix();
	}

	touchMatrix() {
		if(!validate())
			return(nil);
		setDimensions();
		return(true);
	}

	// Wraps an matrix around an existing vector-of-vectors.  Relies
	// on the caller to validate the argument.
	// This is mostly done as a performance tweak for the various
	// arithmatic methods that construct known-valid vector-of-vector
	// matrix definitions (the thing that will live in matrix in
	// an instance), so going through the constructor would just
	// be burning cycles creating a new copy of the valid new data.
	_wrap(v) {
		local r;

		r = createInstanceOfSelf();
		r.matrix = v;
		r.setDimensions();

		return(r);
	}

	setDimensions() {
		rows = (matrix ? matrix.length : 0);
		columns = ((matrix && matrix.length) ? matrix[1].length : 0);
	}

	markDirty() {
		_transpose = nil;
	}

	// Create a matrix with the given number of rows, columns, and
	// default value.
	createMatrix(r, c, v?) {
		local i;

		v = (v ? v : defaultValue);

		matrix = new Vector(r);
		for(i = 0; i < r; i++)
			matrix.append(new Vector(c).fillValue(v, 1, c));
		setDimensions();
	}

	// Load a matrix from a row-first array-of-arrays argument.
	loadMatrix(v) {
		if(!validate(v))
			return(nil);

		matrix = new Vector(v.length);
		v.forEach({ x: matrix.append(new Vector(x)) });
		markDirty();
		setDimensions();

		return(true);
	}

	validate(v?) {
		v = (v ? v : matrix);

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

	clone() { return(createInstanceOfSelf(matrix)); }

	// Fill the matrix with a single value.
	fill(v) {
		if(!matrix) return(nil);

		matrix.forEach({ x: x.fillValue(v, 1, matrix[1].length) });
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
		matrix.forEach({ x: r.append(x.mapAll({ y: y * v })) });

		return(_wrap(r));
	}

	mapAll(fn) {
		local r;

		if(!isFunction(fn))
			return(nil);

		r = new Vector(rows);
		matrix.forEach({ x: r.append(x.mapAll({ y: (fn)(y) })) });

		return(_wrap(r));
	}

	multiplyVector(v) {
		local r;

		r = new Vector(v.length);
		matrix.forEach({ x: r.append(v.dot(x)) });

		return(r);
	}

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
				v.append(matrix[i][j]);
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
		return(matrix ? matrix[i] : nil);
	}

	unsafeGetRow(i) {
		return(matrix ? matrix[i] : nil);
	}

	get(i, j) {
		if(!_validateCoord(i, j)) return(nil);
		return(matrix ? matrix[i][j] : nil);
	}

	set(i, j, v) {
		if(!matrix) return(nil);
		if(!_validateCoord(i, j)) return(nil);
		matrix[i][j] = v;
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
		return(matrix ? matrix.mapAll({ x: x.maxAbs() }).maxVal()
			: nil);
	}

	log() {
		if(!matrix) "\nno matrix\n ";
		matrix.forEach({ x: "\n[ <<x.join(', ')>> ]\n " });
	}

	forEach(fn) { return(matrix.forEach(fn)); }

	// Sets the value of of column j in every row to be value n,
	// defaulting to zero if n is not given.
	setColumnValue(j, n?) {
		if(!matrix) return(nil);
		n = (n ? n : 0);
		matrix.forEach({ x: x[j] = n });
		markDirty();
		return(true);
	}

	// Returns column j as a new vector.
	// IMPORTANT:  offline copy; can't be used to update matrix.
	getColumn(j) {
		return(Vector.generate({ x: matrix[x][j] }, rows));
	}
;
