#charset "us-ascii"
//
// tsProf.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

#ifdef __DEBUG

class TSProf: object
	label = 'tsProf'

	_ts = perInstance(new LookupTable())
	_val = perInstance(new LookupTable())

	start(id) { _ts[id] = new TS(); }
	stop(id) {
		local ts;

		if((ts = _ts[id]) == nil) return(nil);
		_val[id] = (_val[id] ? _val[id] : 0) + ts.getInterval();
		_ts.removeElement(id);
		
		return(true);
	}

	total(id) { return(_val[id] ? _val[id] : 0); }

	report() {
		"\n=====<<label>> START=====\n ";
		_val.forEachAssoc({
			k, v: "\n<<toString(k)>>: <<toString(v)>>\n "
		});
		"\n=====<<label>> END=====\n ";
	}
;

#endif // __DEBUG
