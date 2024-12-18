#charset "us-ascii"
//
// tuple.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataStructures.h"

class Tuple: object
	srcObject = nil		// object action comes from
	srcActor = nil		// actor action comes from
	dstObject = nil		// object receiving action
	dstActor = nil		// actor receiving action
	action = nil		// action type
	room = nil		// location of action

	construct(cfg?) {
		parseCfg(cfg);
		canonicalizeTuple();
	}

	parseCfg(cfg?) {
		if(cfg == nil) cfg = object {};
		cfg.getPropList().forEach(function(o) {
			if(!cfg.propDefined(o, PropDefDirectly)) return;
			if(!self.propDefined(o)) return;
			self.(o) = cfg.(o);
		});
	}

	canonicalizeTuple() {
		local v;

		if((v = canonicalizeObject(srcObject)) != nil) {
			srcObject = v[1];
			srcActor = v[2];
		}
		if((v = canonicalizeObject(dstObject)) != nil) {
			dstObject = v[1];
			dstActor = v[2];
		}
		action = canonicalizeAction(action);
		room = canonicalizeLocation(room);
	}

	canonicalizeObject(v) {
		if(!isThing(v)) return(nil);
		if(v.ofKind(Actor))
			return([ nil, v ]);
		else
			return([ v, v.getCarryingActor() ]);
	}

	canonicalizeAction(v) { return(isAction(v) ? v : nil); }
	canonicalizeLocation(v)
		{ return(isLocation(v) ? v.getOutermostRoom() : nil); }

	_matchProp(v, cls) {
		local i;

		// No criteria, always matches.
		if(cls == nil) return(true);

		// No arg, always fails.
		if(v == nil) return(nil);

		if(cls.ofKind(Collection)) {
			for(i = 1; i <= cls.length; i++) {
				if((cls[i] == v) || v.ofKind(cls[i]))
					return(true);
			}
			return(nil);
		}

		if(v == cls) return(true);

		return(v.ofKind(cls));
	}

	matchSrcObject(v)
		{ return(_matchProp(v, srcObject)); }
	matchSrcActor(v)
		{ return(_matchProp(v, srcActor)); }
	matchDstObject(v)
		{ return(_matchProp(v, dstObject)); }
	matchDstActor(v)
		{ return(_matchProp(v, dstActor)); }
	matchAction(v)
		{ return(_matchProp(v, action)); }
	matchLocation(v)
		{ return(_matchProp(v, room)); }
	matchSrcAndDstObjects(v0, v1)
		{ return(matchSrcObject(v0) && matchDstObject(v1)); }
	matchSrcAndDstActors(v0, v1)
		{ return(matchSrcActor(v0) && matchDstActor(v1)); }

	matchTupleExact(v) {
		if(!isTuple(v)) return(nil);
		if(action != v.action) return(nil);
		if(dstObject != v.dstObject) return(nil);
		if(srcActor != v.srcActor) return(nil);
		if(srcObject != v.srcObject) return(nil);
		if(dstActor != v.dstActor) return(nil);
		if(room != v.room) return(nil);
		return(true);
	}

	matchTuple(v) {
		if(!isTuple(v)) return(nil);
		if(action && !matchAction(v.action)) return(nil);
		if(dstObject && !matchDstObject(v.dstObject)) return(nil);
		if(srcActor && !matchSrcActor(v.srcActor)) return(nil);
		if(dstActor && !matchDstActor(v.dstActor)) return(nil);
		if(srcObject && !matchSrcObject(v.srcObject)) return(nil);
		if(room && !matchLocation(v.room)) return(nil);

		return(true);
	}
;
