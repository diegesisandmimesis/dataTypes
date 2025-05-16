#charset "us-ascii"
//
// lineSegment.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

#ifdef USE_XY

enum _eZero, _ePositive, _eNegative;

class LineSegment: object
	_v0 = nil
	_v1 = nil
	construct(v0, v1) {
		if(isXY(v0)) _v0 = v0;
		if(isXY(v1)) _v1 = v1;
	}

	contains(v) {
		if(!isXY(v)) return(nil);
		return((v.x <= max(_v0.x, _v1.x))
			&& (v.x >= min(_v0.x, _v1.x))
			&& (v.y <= max(_v0.y, _v1.y))
			&& (v.y >= min(_v0.y, _v1.y)));
	}

	_spin(v0, v1, v2) {
		local r;

		r = ((v1.y - v0.y) * (v2.x - v1.x))
			- ((v1.x - v0.x) * (v2.y - v1.y));

		if(r == 0)
			return(_eZero);

		return((r > 0) ? _ePositive : _eNegative);
	}

	equals(v) {
		if(!isLineSegment(v)) return(nil);
		return((_v0.equals(v._v0) && _v1.equals(v._v1))
			&& (_v1.equals(v._v0) && _v0.equals(v._v1)));
	}

	coincident(v) {
		if(!isLineSegment(v)) return(nil);

		return((_v0.equals(v._v0) || _v1.equals(v._v0)
			|| _v0.equals(v._v1) || _v1.equals(v._v1))
			&& !equals(v));
	}

	intersects(v, ignoreEndpoints?) {
		local ar;

		if(!isLineSegment(v)) return(nil);

		ar = [
			_spin(_v0, _v1, v._v0),
			_spin(_v0, _v1, v._v1),
			_spin(v._v0, v._v1, _v0),
			_spin(v._v0, v._v1, _v1)
		];

		if((ar[1] != ar[2]) && (ar[3] != ar[4]))
			return(true);

		if(ignoreEndpoints == true)
			return(nil);

		if((ar[1] == _eZero) && contains(v._v0))
			return(true);
		if((ar[2] == _eZero) && contains(v._v1))
			return(true);
		if((ar[3] == _eZero) && v.contains(_v0))
			return(true);
		if((ar[4] == _eZero) && v.contains(_v1))
			return(true);

		return(nil);
	}
	toStr() { return('<<_v0.toStr()>> <<_v1.toStr()>>'); }
;

#endif // USE_XY
