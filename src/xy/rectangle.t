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
		if(isXY(x))
			return(_contains(x));
		else if(isRectangle(x))
			return(_contains(x.corner0) && _contains(x.corner1));
		else
			return(_contains(new XY(x, y)));
	}

	_contains(v) {
		if(!isXY(v)) return(nil);

		return((v.x >= corner0.x) && (v.x <= corner1.x)
			&& (v.y >= corner0.y) && (v.y <= corner1.y));
	}

	// Returns boolean true if the point (or rectangle) given by the
	// arg overlaps this rectangle.
	overlaps(x, y?) {
		// Check to see if the args look like a point.  If so,
		// overlaps() is just contains().
		if(isXY(x))
			return(_contains(x));
		else if(!isRectangle(x))
			return(_contains(new XY(x, y)));

		// If we're here, the first arg is a rectangle.
		return(!((x.corner1.x < corner0.x)
			|| (x.corner0.x > corner1.x)
			|| (x.corner1.y < corner0.y)
			|| (x.corner0.y > corner1.y)));
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
		local v0, v1;

		if(isXY(x))
			v0 = x;
		else
			v0 = new XY(x, y);

		v1 = new XY(0, 0);
		if(v0.x < corner0.x) v1.x = corner0.x;
		if(v0.x > corner1.x) v1.x = corner1.x;
		if(v0.y < corner0.y) v1.y = corner0.y;
		if(v0.y > corner1.y) v1.y = corner1.y;

		return(v0.subtract(v1));
	}

	// Returns the minimum Manhattan/taxi distance between our
	// bounding box and the given point.
	manhattanDistance(x, y?) {
		local d;

		d = offset(x, y);

		return(d.x + d.y);
	}

	// Returns the area of the rectangle if expanded to include the
	// given rectangle.  Does not actually expand the rectangle.
	areaWith(x0, y0?, x1?,y1?) {
		local v0, v1, lx0, ly0, lx1, ly1;

		if(isRectangle(x0)) {
			v0 = x0.corner0;
			v1 = x0.corner1;
		} else if(isXY(x0) && isXY(y0)) {
			v0 = x0;
			v1 = y0;
		} else if(isXY(x0)) {
			v0 = x0;
			v1 = x0;
		} else {
			v0 = new XY(x0, y0);
			v1 = new XY(x1, y1);
		}

		lx0 = corner0.x;
		lx1 = corner1.x;
		ly0 = corner0.y;
		ly1 = corner1.y;

		if(v0.x < lx0) lx0 = v0.x;
		if(v0.y < ly0) ly0 = v0.y;
		if(v0.x > lx1) lx1 = v0.x;
		if(v0.y > ly1) ly1 = v0.y;

		if(v1.x < lx0) lx0 = v1.x;
		if(v1.y < ly0) ly0 = v1.y;
		if(v1.x > lx1) lx1 = v1.x;
		if(v1.y > ly1) ly1 = v1.y;

		return((lx1 - lx0) * (ly1 - ly0));
	}

	// Height and width of the rectangle.
	width = (corner1.x - corner0.x)
	height = (corner1.y - corner0.y)

	area = (width * height)

	// Returns the coordinates of the given corners.
	upperLeft = (new XY(corner0.x, corner0.y))
	upperRight = (new XY(corner1.x, corner0.y))
	lowerLeft = (new XY(corner0.x, corner1.y))
	lowerRight = (new XY(corner1.x, corner1.y))

	center = (corner0.add(new XY(width / 2, height / 2)))

	toStr() { return('<<corner0.toStr()>> <<corner1.toStr()>> '
		+ '<<toString(width)>> x <<toString(height)>>'); }

	constructAdjacent(x, y?) {
		local p, v;

		if(isXY(x)) v = x;
		else v = new XY(x, y);

		v.x = (v.x ? abs(v.x) / v.x : 0);
		v.y = (v.y ? abs(v.y) / v.y : 0);

		p = new XY(corner0.x + (v.x * (width + 1)),
			corner0.y + (v.y * (height + 1)));

		return(new Rectangle(
			p.x, p.y,
			p.x + width,
			p.y + height
		));
	}
;

#endif // USE_XY
