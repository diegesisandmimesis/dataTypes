#charset "us-ascii"
//
// quadTree.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

#ifdef USE_XY

// Data class for leaf nodes.
class QuadTreeData: object
	position = nil		// XY instance
	data = nil		// user data

	construct(v0, v1) {
		position = v0;
		data = v1;
	}
;

// Simple quadtree implementation
class QuadTree: object
	// User data for leaf nodes.
	data = nil

	// Node's bounding box.
	_boundingBox = nil

	// List of node's branches.
	_branches = nil

	// Constructor, which accepts several syntaxes for declaring the
	// bounding box.
	construct(x0, y0?, x1?, y1?) {
		local v;

		if(isRectangle(x0)) {
			v = x0;
		} else if(isXY(x0) && isXY(y0)) {
			v = new Rectangle(x0, y0);
		} else {
			v = new Rectangle(x0, y0, x1, y1);
		}

		setBoundingBox(v);
	}

	// Returns the bounding box, without fail.
	getBoundingBox() {
		if(_boundingBox == nil)
			_boundingBox = new Rectangle();
		return(_boundingBox);
	}

	// Sets the bounding box.
	setBoundingBox(v) {
		if(!isRectangle(v))
			return(nil);
		_boundingBox = v;
		return(true);
	}

	// Inserts a new value.  Args are the position, as an x-y, and the
	// data.
	insert(x, y, d?) {
		local i, v;

		if(isXY(x)) {
			v = x;
			d = y;
		} else {
			v = new XY(x, y);
		}

		// If the location for the insert isn't in our bounding
		// box we have nothing to do.
		if(!getBoundingBox().contains(v))
			return(nil);

		// If we don't have any branches just add the data on
		// ourselves.
		if((data == nil) && (_branches == nil)) {
			data = new QuadTreeData(v, d);
			return(true);
		}

		// If we're here, then that means we do have data.  If
		// we don't have branches yet, we need to construct some.
		if(_branches == nil)
			_subdivide();

		for(i = 1; i <= _branches.length; i++) {
			if(_branches[i].insert(v, d) == true) {
				return(true);
			}
		}

		return(nil);
	}

	// Construct our branches.  They will be four QuadTree instances
	// which each cover a quarter of our area.
	_subdivide() {
		local bb, m, v0, v1;

		// Our bounding box.
		bb = getBoundingBox();

		// Assign some variables to our points of interest.
		v0 = bb.corner0;	// upper left
		v1 = bb.corner1;	// lower right
		m = bb.center;		// dead center

		// Create the branches.
		_branches = [
			new QuadTree(v0.x, v0.y, m.x, m.y),
			new QuadTree(m.x + 1, v0.y, v1.x, m.y),
			new QuadTree(v0.x, m.y + 1, m.x, v1.y),
			new QuadTree(m.x + 1, m.y + 1, v1.x, v1.y)
		];

		// Since we're creating branches that means we already
		// have data (and just got an insert for more) so we
		// need to push that down onto one of our new branches.
		_branches.forEach({ x: x.insert(data.position, data.data) });

		// Clear our data (it is now on a branch).
		data = nil;
	}

	delete(x, y, d?) {
	}

	// Query.  Returns a list of matching QuadTreeData instances.
	_query(x0, y0?, x1?, y1?) {
		local bb, r, v;

		if(isRectangle(x0))
			v = x0;
		else if(isXY(x0) && isXY(y0))
			v = new Rectangle(x0, y0);
		else if(isXY(x0) && (y0 == nil))
			v = new Rectangle(x0, x0);
		else if((x1 == nil) && (y1 == nil))
			v = new Rectangle(x0, y0, x0, y0);
		else
			v = new Rectangle(x0, y0, x1, y1);

		bb = getBoundingBox();
		if(!bb.overlaps(v))
			return([]);

		if((data != nil) && v.overlaps(data.position)) {
			return([ data ]);
		}

		if(_branches == nil)
			return([]);

		r = new Vector();
		_branches.forEach({ x: r.appendUnique(x._query(v)) });

		return(r);
	}

	// Wrapper for _query().  Returns a list of the data records
	// instead of QuadTreeData instances.
	query(x0, y0?, x1?, y1?) {
		local l, r;

		l = _query(x0, y0, x1, y1);
		r = new Vector(l.length());
		l.forEach({ x: r.append(x.data) });
		return(r.toList());
	}
;

#endif // USE_XY
