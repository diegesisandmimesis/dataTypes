#charset "us-ascii"
//
// AsciiCanvas.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

#ifdef USE_ASCII_CANVAS

class AsciiCanvas: object
	_matrix = nil		// vector for the array
	_size = nil		// size of canvas (XY instance)
	_center = nil		// center of canvas (XY instance)

	_legend = nil		// legend (for converting canvas values
				//	into labels)

	_labels = nil		// For auto-generated labels
	_labelIdx = 0

	blankChr = '.'		// default value for "empty" square

	construct(w?, h?) {
		// Store the size of the canvas.
		if(isXY(w)) {
			_size = w;
		} else {
			_size = new XY(w ? w : 32, h ? h : 32);
		}

		// Compute and save the center of the canvas.
		_center = _size.divide(2);

		// Generate the Vector to hold the canvas.
		_matrix = new Matrix0(_size.x, _size.y);
	}

	clear() {
		_matrix.free();
		_matrix = nil;
		_size = nil;
		_center = nil;
		_legend = nil;
		_labels = nil;
		_labelIdx = 0;
	}

	getCenter() { return(_center); }

	// Associates a canvas value k with a label v.
	addLegend(k, v) {
		// Create the legend lookup table if it doesn't exist.
		if(_legend == nil)
			_legend = new LookupTable();

		// If the value was nil, we pick one.
		if(k == nil)
			k = getLabel();

		// Remember the association.
		_legend[k] = v;

		// Returns the key.  Useful mostly when called with k nil.
		return(k);
	}

	//
	getLabel() {
		if(_labels == nil)
			_initLabels();

		// If we run out of labels, wrap.  Confusing but unlikely;
		// left to individual instances to handle their own way
		// if there are more than 72 things in the canvas.
		_labelIdx = (_labelIdx % _labels.length) + 1;

		return(_labels[_labelIdx]);
	}

	// Create an array of A-Z and a-z, to be assigned as labels for
	// callers that don't want to do it "manually".
	_initLabels() {
		local i;

		_labels = new Vector();
		for(i = 0; i < 26; i++) _labels.append(makeString(65 + i));
		for(i = 0; i < 26; i++) _labels.append(makeString(97 + i));

		// Index for keeping track of which labels have been used.
		_labelIdx = 0;
	}

	// Getter and setter for canvas array.
	getXY(x, y?) {
		local v;
		if(isXY(x)) v = x;
		else v = new XY(x, y);
		return(_matrix ? _matrix.get(v.x, v.y) : nil);
	}
	setXY(x, y, d?) {
		local v;
		if(isXY(x)) {
			v = x;
			d = y;
		} else {
			v = new XY(x, y);
		}
		return(_matrix ? _matrix.set(v.x, v.y, d) : nil);
	}

	_lineLow(v0, v1, v) {
		local delta, d, yi, x, y;

		delta = v1.subtract(v0);

		if(delta.y < 0) {
			yi = -1;
			delta.y = -delta.y;
		} else {
			yi = 1;
		}
		d = (2 * delta.y) - delta.x;
		y = v0.y;
		for(x = v0.x; x <= v1.x; x++) {
			setXY(x, y, v);
			if(d > 0) {
				y += yi;
				d += (2 * (delta.y - delta.x));
			} else {
				d = d + (2 * delta.y);
			}
		}
	}

	_lineHigh(v0, v1, v) {
		local delta, d, xi, x, y;

		delta = v1.subtract(v0);
		if(delta.x < 0) {
			xi = -1;
			delta.x = -delta.x;
		} else {
			xi = 1;
		}
		d = (2 * delta.x) - delta.y;
		x = v0.x;
		for(y = v0.y; y <= v1.y; y++) {
			setXY(x, y, v);
			if(d > 0) {
				x += xi;
				d += (2 * (delta.x - delta.y));
			} else {
				d += (2 * delta.x);
			}
		}
	}

	// Bresenham's algorithm for drawing a line using only
	// integer math.
	line(x0, y0, x1, y1?, v?) {
		local v0, v1;

		if(isXY(x0) && isXY(y0)) {
			v0 = x0;
			v1 = y0;
			v = x1;
		} else {
			v0 = new XY(x0, y0);
			v1 = new XY(x1, y1);
		}
		if(abs(v1.y - v0.y) < abs(v1.x - v0.x)) {
			if(v0.x > v1.x) {
				_lineLow(v1, v0, v);
			} else {
				_lineLow(v0, v1, v);
			}
		} else {
			if(v0.y > v1.y) {
				_lineHigh(v1, v0, v);
			} else {
				_lineHigh(v0, v1, v);
			}
		}
	}

	// Implementation of the midpoint circle algorithm
	circle(x0, y0, r, v?) {
		local d, v0, x, y;

		if(isXY(x0)) {
			v0 = x0;
			v = r;
			r = y0;
		} else {
			v0 = new XY(x0, y0);
		}

		d = (5 - r * 4) / 4;
		x = 0;
		y = r;

		while(x <= y) {
			if((v0.x + x >= 0) && (v0.y + y >= 0))
				setXY(v0.x + x, v0.y + y, v);
			if((v0.x + x >= 0) && (v0.y - y >= 0))
				setXY(v0.x + x, v0.y - y, v);
			if((v0.x - x >= 0) && (v0.y + y >= 0))
				setXY(v0.x - x, v0.y + y, v);
			if((v0.x - x >= 0) && (v0.y - y >= 0))
				setXY(v0.x - x, v0.y - y, v);
			if((v0.x + y >= 0) && (v0.y + x >= 0))
				setXY(v0.x + y, v0.y + x, v);
			if((v0.x + y >= 0) && (v0.y - x >= 0))
				setXY(v0.x + y, v0.y - x, v);
			if((v0.x - y >= 0) && (v0.y + x >= 0))
				setXY(v0.x - y, v0.y + x, v);
			if((v0.x - y >= 0) && (v0.y - x >= 0))
				setXY(v0.x - y, v0.y - x, v);
			if(d < 0) {
				d += (2 * x) + 1;
			} else {
				d += (2 * (x - y) + 1);
				y--;
			}
			x++;
		}
	}

	rectangleFill(x0, y0, x1, y1?, v?) {
		local i, j, v0, v1;

		if(isXY(x0) && isXY(y0)) {
			v0 = x0;
			v1 = y0;
			v = x1;
		} else {
			v0 = new XY(x0, y0);
			v1 = new XY(x1, y1);
		}

		for(j = v0.y; j <= v1.y; j++) {
			for(i = v0.x; i <= v1.x; i++) {
				setXY(i, j, v);
			}
		}
	}

	rectangle(x0, y0, x1, y1?, v?) {
		local v0, v1;

		if(isXY(x0) && isXY(y0)) {
			v0 = x0;
			v1 = y0;
			v = x1;
		} else {
			v0 = new XY(x0, y0);
			v1 = new XY(x1, y1);
		}

		line(v0.x, v0.y, v1.x, v0.y, v);
		line(v0.x, v1.y, v1.x, v1.y, v);
		line(v0.x, v0.y, v0.x, v1.y, v);
		line(v1.x, v0.y, v1.x, v1.y, v);
	}

	// Fill the canvas with the given value.
	fill(v) { if(_matrix) _matrix.fill(v); }

	// Simple output method.
	display() {
		local buf, i, j, v;

		if(_matrix == nil) return;

		buf = new StringBuffer((_size.x * _size.y) + _size.y + 1);
		for(j = 0; j < _size.y; j++) {
			for(i = 0; i < _size.x; i++) {
				v = getXY(i, j);
				buf.append(v ? v : blankChr);
			}
			buf.append('\n');
		}
		"<<buf>>\n ";
	}
;

#endif // USE_ASCII_CANVAS
