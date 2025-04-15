#charset "us-ascii"
//
// rTree.t
//
//	Simple R-tree implementation.
//
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

		if(isXY(v0)) {
			corner0 = v0.clone();
			corner1 = v1.clone();
		} else {
			corner0 = new XY(v0, v1);
			corner1 = new XY(v2, v3);
		}
		if(corner0.x > corner1.x) {
			t = corner1.x;
			corner1.x = corner0.x;
			corner0.x = t;
		}

		if(corner0.y > corner1.y) {
			t = corner1.y;
			corner1.y = corner0.y;
			corner0.y = t;
		}
	}

	clone() {
		return(new Rectangle(corner0 ? corner0.clone() : nil,
			corner1 ? corner1.clone() : nil));
	}

	contains(x, y?) {
		local v;

		if(isXY(x))
			v = x;
		else
			v = new XY(x, y);

		return((v.x >= corner0.x) && (v.x <= corner1.x)
			&& (v.y >= corner0.y) && (v.y <= corner1.y));
	}

	expand(x, y?) {
		local v;

		if(isXY(x))
			v = x;
		else
			v = new XY(x, y);

		if(v.x < corner0.x) corner0.x = v.x;
		if(v.y < corner0.y) corner0.y = v.y;
		if(v.x > corner1.x) corner1.x = v.x;
		if(v.y > corner1.y) corner1.y = v.y;
	}
;

class RTree: object
	_rect = nil

	next = nil
	prev = nil

	data = nil

	root = nil

	construct(parent?) {
		if(isRTree(parent)) {
			data = parent.data;
			if(isRectangle(parent._rect))
				_rect = parent._rect.clone();
			parent.addLeaf(self);
		}
	}

	isLeaf() { return(next == nil); }
	isRoot() { return(root == true); }

	addLeaf(obj) {
		if(!isRTree(obj)) return(nil);

		if(next == nil) next = new Vector();
		obj.prev = self;
		next.append(obj);

		return(true);
	}

	insert(x, y, v?) {
		local pos;

		if(isXY(x)) {
			pos = x;
			v = y;
		} else {
			pos = new XY(x, y);
		}

		if(!isXY(pos)) return(nil);

		// A nil rectangle implies we're a new leaf node.
		if(_rect == nil) return(_insertNew(pos, v));

		if(_rect.contains(pos))
			return(_insertOverlap(pos, v));

		return(_insertDisjoint(pos, v));
	}

	_insertNew(pos, v) {
		_rect = new Rectangle(pos, pos);

		data = new Vector();
		data.append(v);

		return(true);
	}

	_insertOverlap(pos, v) {
		local i;

		if(next != nil) {
			for(i = 1; i <= next.length; i++) {
				if(next[i].insert(pos, v)) return(true);
			}
		}
		data.append(v);

		return(true);
	}

	_insertDisjoint(pos, v) {
		local obj;

		next = new Vector();

		obj = new RTree(self);

		obj = new RTree();
		obj.insert(pos, v);
		next.append(obj);

		_rect.expand(pos);

		return(true);
	}

	get(x, y?) {
		local i, l, v, r;

		if(isXY(x))
			v = x;
		else
			v = new XY(x, y);

		if((_rect == nil) || !_rect.contains(v)) return(nil);

		if(next == nil)
			return(data);

		r = new Vector();
		for(i = 1; i <= next.length; i++) {
			if((l = next[i].get(v)) != nil)
				r.appendUnique(l);
		}

		return(r);
	}
;

#endif // USE_XY
