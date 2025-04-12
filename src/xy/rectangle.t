#charset "us-ascii"
//
// rectangle.t
//
//	Datatype for holding rectangles.
//
// USAGE
//
//	Rectangles are specified by the coordinates of their upper left
//	and lower right corners.
//
//		// Rectangle with corners (1, 2) and (8, 4)
//		//	 01234556789
//		//	0...........
//		//	1...........
//		//	2.#########.
//		//	3.#.......#.
//		//	4.#########.
//		//	5...........
//		local rect0 = new Rectangle(1, 2, 8, 4);
//
//		// Equivalent to the above
//		local v0 = new XY(1, 2);
//		local v1 = new XY(8, 4);
//		local rect1 = new Rectangle(v0, v1);
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

#ifdef USE_XY

// Rectangle class.  Defines a bounding rectangle by its corners.
class Rectangle: object
	corner0 = nil
	corner1 = nil

	construct(v0, v1, v2?, v3?) {
		local t;

		// Figure out if we have two XY instances or four
		// integers.
		if(isXY(v0) && isXY(v1)) {
			corner0 = v0.clone();
			corner1 = v1.clone();
		} else {
			corner0 = new XY(v0, v1);
			corner1 = new XY(v2, v3);
		}

		// Make sure corner0 is to the left of corner1.
		if(corner0.x > corner1.x) {
			t = corner1.x;
			corner1.x = corner0.x;
			corner0.x = t;
		}

		// Make sure corner0 is above corner1.
		if(corner0.y > corner1.y) {
			t = corner1.y;
			corner1.y = corner0.y;
			corner0.y = t;
		}
	}

	// Returns a copy of this rectangle.
	clone() {
		return(new Rectangle(corner0 ? corner0.clone() : nil,
			corner1 ? corner1.clone() : nil));
	}

	// Returns boolean true if the given location is inside this
	// rectangle.
	contains(x, y?) {
		local v;

		if(isXY(x))
			v = x;
		else
			v = new XY(x, y);

		return((v.x >= corner0.x) && (v.x <= corner1.x)
			&& (v.y >= corner0.y) && (v.y <= corner1.y));
	}

	// Expand the rectangle to include the given point.
	expand(x, y?) {
		if(isXY(x)) {
			_expand(x);
		} else if(isRectangle(x)) {
			_expand(x.corner0);
			_expand(x.corner1);
		} else {
			_expand(new XY(x, y));
		}
	}

	// Helper method for the above.
	_expand(v) {
		if(!isXY(v)) return;
		if(v.x < corner0.x) corner0.x = v.x;
		if(v.y < corner0.y) corner0.y = v.y;
		if(v.x > corner1.x) corner1.x = v.x;
		if(v.y > corner1.y) corner1.y = v.y;
	}

	// Returns the minimum offset between our bounding box and
	// the given point.
	offset(x, y?) {
		local v;

		if(isXY(x))
			v = x;
		else
			v = new XY(x, y);

		x = 0;
		y = 0;

		if(v.x < corner0.x) x = corner0.x - v.x;
		if(v.x > corner1.x) x = v.x - corner1.x;
		if(v.y < corner0.y) y = corner0.y - v.y;
		if(v.y > corner1.y) y = v.y - corner1.y;

		return(new XY(x, y));
	}

	// Returns the minimum Manhattan/taxi distance between our
	// bounding box and the given point.
	manhattanDistance(x, y?) {
		local d;

		d = offset(x, y);

		return(d.x + d.y);
	}

	// Height and width of the rectangle.
	width = (corner1.x - corner0.x)
	height = (corner1.y - corner0.y)

	// Returns the coordinates of the given corners.
	upperLeft = (new XY(corner0.x, corner0.y))
	upperRight = (new XY(corner1.x, corner0.y))
	lowerLeft = (new XY(corner0.x, corner1.y))
	lowerRight = (new XY(corner1.x, corner1.y))
	
;

#endif // USE_XY
