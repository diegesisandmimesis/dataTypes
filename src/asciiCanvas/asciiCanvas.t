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
	_canvas = nil		// vector for the array
	_size = nil		// size of canvas (XY instance)
	_center = nil		// center of canvas (XY instance)

	blankChr = '.'		// default value for "empty" square

	construct(w?, h?) {
		// Store the size of the canvas.
		_size = new XY(w ? w : 32, h ? h : 32);

		// Compute and save the center of the canvas.
		_center = _size.divide(2);

		// Generate the Vector to hold the canvas.
		_canvas = Vector.generate({ i: nil }, _size.x * _size.y);
	}

	clear() {
		_canvas.setLength(0);
		_canvas = nil;
		_size = nil;
		_center = nil;
	}

	// Convert coordinates to an index in the canvas array.
	// Can be called with one argument (an XY instance) or
	// two (two integer values).
	xyToIndex(x, y?) {
		local v0, v1;

		if(_canvas == nil) return(nil);
		if((x >= _size.x) || (x < 0)) return(nil);
		if((y >= _size.y) || (y < 0)) return(nil);
		if(isXY(x)) { v0 = x.x; v1 = x.y; }
		else { v0 = x; v1 = y; }

		return((v0 % _size.x) + ((v1 % _size.y) * _size.x) + 1);
	}

	// Getter and setter for canvas array.
	getXY(x, y?) {
		local idx;

		if((idx = xyToIndex(x, y)) == nil) return(nil);
		return(_canvas ? _canvas[idx] : nil);
	}
	setXY(x, y, v?) {
		local idx;

		if(_canvas == nil) return;
		if(isXY(x)) { v = y; y = nil; }
		if((idx = xyToIndex(x, y)) == nil) return;
		_canvas[idx] = v;
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

	// Fill the canvas with the given value.
	fill(v) { _canvas.fillValue(v, 1, _size.x * _size.y); }

	// Simple output method.
	log() {
		local buf, i, j, v;

		if(_canvas == nil) return;

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
