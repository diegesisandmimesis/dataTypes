#charset "us-ascii"
//
// spline.t
//
//	Datatype for holding x-y coordinates.
//
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

#ifdef USE_XY

// Useless stub at this point, mostly a placeholder because MAYBE
// there will be other spline types.
class Spline: object
	initSpline() {}
;

class BezierSpline: Spline
	segments = 16		// number of spline segments

	p0 = nil		// endpoint
	p1 = nil		// control point
	p2 = nil		// endpoint

	a1 = nil		// constructed

	_points = nil		// array containing the points

	xyClass = _XY		// class to use for xy values

	scale = 64		// arbitrary integer scale factor

	construct(v0?, v1?, v2?) {
		if(isXY(v0)) p0 = v0;
		if(isXY(v1)) p1 = v1;
		if(isXY(v2)) p2 = v2;
	}

	initSpline() {
		if(_points != nil)
			return;

		// Figure out if we have an existing control point or if
		// we have to compute the midpoint of a line segment.
		if(a1 == nil) {
			if(p1 != nil) {
				a1 = p1;
			} else {
				a1 = xyClass.createInstance(
					(p0.x + p2.x) / 2,
					(p0.y + p2.y) / 2
				);
			}
		}

		_initSplinePoints(a1);
	}

	// Compute the points for a quadratic Bezier curve.
	_initSplinePoints(a1) {
		local i, n, n2, t0, t1, v0, v1, v2;

		_points = new Vector(segments + 1);

		n = segments;
		n2 = n * n;

		for(i = 0; i <= n; i++) {
			t1 = i;
			t0 = n - i;

			// Precompute values for the polynomial that
			// we use multiple times.
			v0 = t0 * t0;
			v1 = 2 * t0 * t1;
			v2 = t1 * t1;

			_points.append(xyClass.createInstance(
				(((v0 * p0.x) + (v1 * a1.x)
					+ (v2 * p2.x)) * scale) / n2,
				(((v0 * p0.y) + (v1 * a1.y)
					+ (v2 * p2.y)) * scale) / n2
			));
		}
	}

	// Returns the index of the spline point nearest to the argument
	// point (which is assumed to be an XY instance).
	nearestPointTo(p) {
		local d, i, n, minD, r, x, y;

		if(!_points)
			return(nil);
		r = 1;
		minD = nil;
		n = _points.length;

		for(i = 1; i <= n; i++) {
			x = p.x - _points[i].x;
			y = p.y - _points[i].y;
			d = (x * x) + (y * y);
			if((minD == nil) || (d < minD)) {
				minD = d;
				r = i;
			}
		}

		return(r);
	}
;


#endif // USE_XY
