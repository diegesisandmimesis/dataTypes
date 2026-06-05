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

class Spline: object
;

class BezierSpline: Spline
	_points = nil

	p0 = nil
	p1 = nil
	p2 = nil

	a1 = nil

	xyClass = _XY

	scale = 64
	segments = 16

	construct(v0?, v1?, v2?) {
		if(isXY(v0)) p0 = v0;
		if(isXY(v1)) p1 = v1;
		if(isXY(v2)) p2 = v2;
	}

	initSpline() {
		if(_points != nil)
			return;

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

	_initSplinePoints(a1) {
		local i, n, n2, t0, t1;

		_points = new Vector(segments + 1);

		n = segments;
		n2 = n * n;

		for(i = 0; i <= n; i++) {
			t1 = i;
			t0 = n - i;

			_points.append(xyClass.createInstance(
				(((t0 * t0 * p0.x) + (2 * t0 * t1 * a1.x)
					+ (t1 * t1 * p2.x)) * scale) / n2,
				(((t0 * t0 * p0.y) + (2 * t0 * t1 * a1.y)
					+ (t1 * t1 * p2.y)) * scale) / n2
			));
		}
	}

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
