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
	parent = nil		// where we live

	construct(v0, v1, p) {
		position = v0;
		data = v1;
		parent = p;
	}
;

// Simple quadtree implementation
class QuadTree: object
	// User data for leaf nodes.
	data = nil

	maxData = 10

	prev = nil

	// Node's bounding box.
	_boundingBox = nil

	// List of node's branches.
	next = nil

	// Constructor, which accepts several syntaxes for declaring the
	// bounding box.
	construct(x0, y0?, x1?, y1?, p?) {
		local v;

		if(isRectangle(x0)) {
			v = x0;
		} else if(isXY(x0) && isXY(y0)) {
			v = new Rectangle(x0, y0);
		} else {
			v = new Rectangle(x0, y0, x1, y1);
		}

		setBoundingBox(v);

		if(p != nil)
			prev = p;
	}

	isLeafNode() { return(next == nil); }
	isRootNode() { return(prev == nil); }

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
		local v;

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

		// If we have branches, pass the insert off to them.
		if(next != nil)
			return(_insertIntoBranch(v, d));

		// No branches, we're a leaf node.  See if we already
		// have data.
		if(data == nil)
			data = new Vector(maxData);

		// If we can just add the data to ourselves, do so.
		if(data.length < maxData) {
			data.append(new QuadTreeData(v, d, self));
			return(true);
		}

		// We've already got as much data as we can hold, so
		// we do a split.
		_split();

		// Add the new data to a branch when we're done splitting.
		return(_insertIntoBranch(v, d));
	}

	// Create new branches and divide existing data between them.
	_split() {
		_subdivide();
		_distributeData();
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
		next = [
			new QuadTree(v0.x, v0.y, m.x, m.y, self),
			new QuadTree(m.x + 1, v0.y, v1.x, m.y, self),
			new QuadTree(v0.x, m.y + 1, m.x, v1.y, self),
			new QuadTree(m.x + 1, m.y + 1, v1.x, v1.y, self)
		];
	}

	// Divide existing data out between our branches.
	_distributeData() {
		if(data == nil)
			return;

		data.forEach({ x: _insertIntoBranch(x.position, x.data) });
		data = nil;
	}

	// Try to insert data into one of our branches.
	_insertIntoBranch(v, d) {
		local i;

		if(next == nil)
			return(nil);

		for(i = 1; i <= next.length; i++) {
			if(next[i].insert(v, d))
				return(true);
		}

		return(nil);
	}

	// Delete a leaf node at the given location with the given data.
	delete(x, y, d?) {
		local n, r, v;

		if(isXY(x)) {
			v = x;
			d = y;
		} else {
			v = new XY(x, y);
		}

		// Find the QuadTreeData instances the query location contains,
		// if any.
		if((r = _query(v)) == nil)
			return(nil);

		// Find the first QuadTreeData instance whose data matches
		// the query.
		if((n = r.valWhich({ x: x.data == d })) == nil)
			return(nil);

		// Remove the instance.
		n.data = nil;
		n.position = nil;
		n.parent._deleteLeaf(n);


		return(true);
	}

	// Delete a leaf from a branch node.
	_deleteLeaf(obj) {
		local idx;

		if(!isQuadTreeData(obj))
			return(nil);

		// Make sure the leaf node is in our data.
		if((data == nil) || ((idx = data.indexOf(obj)) == nil))
			return(nil);

		// Remove it.
		data.removeElementAt(idx);

		// Remove the object's reference to us.
		obj.parent = nil;

		// If that was our last leaf node, see if our
		// branch needs pruning.
		if((data.length == 0) && (next == nil) && (prev != nil))
			prev._deleteBranch(self);

		return(true);
	}

	// Delete a branch if its siblings are also empty.
	_deleteBranch(obj) {
		// Never prune the root node.
		if(isRootNode())
			return(nil);

		// Make sure the arg is a QuadTree instance.
		if(!isQuadTree(obj))
			return(nil);

		// If we're not empty, we don't prune.
		// This relies on branches clearing their leaf nodes before
		// calling us.
		if(!isEmpty())
			return(nil);

		// Remove the branch vector.
		next = nil;

		// If we have a parent, see if we now need to be recursively
		// pruned ourselves.
		if(prev)
			prev._deleteBranch(obj);

		return(true);
	}

	// Returns boolean true if we (and our branches, recursively) contain no
	// data.
	isEmpty() {
		local r;

		// If we have data ourselves then we're not empty.
		if((data != nil) && (data.length > 0))
			return(nil);
		
		// If we have no branches and no data, we're empty.
		if(next == nil)
			return(true);

		// Assume we're empty.
		r = true;

		// Recursively call our branches.  If any of them, or their
		// children, are non-empty, we're non-empty.
		next.forEach(function(o) {
			if(!isQuadTree(o)) return;
			if(!o.isEmpty()) r = nil;
		});

		return(r);
	}

	// Query.  Returns a list of matching QuadTreeData instances
	// or an empty list if there are none.
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

		if(data != nil) {
			r = new Vector();
			data.forEach(function(d) {
				if(v.contains(d.position))
					r.append(d);
			});
			return(r);
		}

		if(next == nil)
			return([]);

		r = new Vector();
		next.forEach({ x: r.appendUnique(x._query(v)) });

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

	quadTreeDebug(d?) {}
;

#ifdef __DEBUG

modify QuadTree
	quadTreeDebug(d?) {
		local indent;

		if(d == nil) d = 0;

		indent = new Vector(d).fillValue('\t', 1, d).join('');

		"\n<<indent>><<(isLeafNode() ? 'leaf' : 'branch')>> node ";
		if(isLeafNode()) {
			"with <<toString(data ? data.length : 'no')>> ";
				"data records\n ";
			return;
		}
		"with <<toString(next.length)>> branches:\n ";
		next.forEach({ x: x.quadTreeDebug(d + 1) });
	}
;

#endif // __DEBUG

#endif // USE_XY
