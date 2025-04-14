#charset "us-ascii"
//
// rTree.t
//
//	Simple R-tree implementation.
//
//	R-trees provide an efficient method for querying spatially-indexed
//	records.
//
//
// USAGE
//
//	Create the root node of the tree and use it to insert and query
//	records.
//
//		// Create a tree
//		local tree = new RTree();
//
//		// Inserts "foo" at (4, 4)
//		tree.insert(4, 4, 'foo');
//
//		// Will assign 'foo' to r.
//		local r = tree.query(4, 4);
//
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

#ifdef USE_XY

class RTree: object
	_boundingBox = nil

	next = nil		// pointer down the branch
	prev = nil		// pointer up the branch

	data = nil		// data record for leaf nodes

	maxBranches = 10	// max number of branches per node

	// Returns boolean true if we're a leaf node.
	isLeafNode() { return(next == nil); }

	// Returns boolean true if we're the root node.
	isRootNode() { return(prev == nil); }

	// Recursively expand our bounding box and our parents' bounding
	// boxen.
	expand(v) {
		getBoundingBox().expand(v);
		if(prev) prev.expand(v);
	}

	// Convenience methods wrapping a method on Rectangle.
	contains(x, y?) { return(getBoundingBox().contains(x, y)); }
	overlaps(x, y?) { return(getBoundingBox().overlaps(x, y)); }
	manhattanDistance(x, y?)
		{ return(getBoundingBox().manhattanDistance(x, y)); }
	areaWith(x0, y0?, x1?, y1?)
		{ return(getBoundingBox().areaWith(x0, y0, x1, y1)); }
	area() { return(getBoundingBox().area); }

	// Returns our bounding box, creating one if we don't have one yet.
	getBoundingBox() {
		if(_boundingBox == nil)
			_boundingBox = new Rectangle(0, 0, 0, 0);
		return(_boundingBox);
	}

	// Sets our bounding box.
	// IMPORTANT:  This generally should only be called internally, as
	//	setting this manually can break queries if the set value
	//	doesn't match the underlying data.
	setBoundingBox(v) {
		// If we're setting from a point, make a "rectangle" whose
		// bounds are that point.
		if(isXY(v))
			_boundingBox = new Rectangle(v, v);
		else if(isRectangle(v))
			_boundingBox = v.clone();
		else
			return(nil);

		return(true);
	}

	// Add a branch node.
	addNode(obj) {
		if(!isRTree(obj)) return(nil);

		// Make sure we have a vector for our branches.
		if(next == nil) next = new Vector();

		// Let the branch know we're its parent.
		obj.prev = self;

		// Add the branch to our list.
		next.append(obj);

		// Expand our bounding box, if necessary, to include
		// the new branch's bounding box.
		expand(obj.getBoundingBox());

		// If adding that branch put us over our limit, do a split.
		if(next.length > maxBranches)
			split();

		return(true);
	}

	// Insert a record at the given position.
	insert(x, y, d?) {
		local b, v;

		if(isXY(x)) {
			v = x;
			d = y;
		} else {
			v = new XY(x, y);
		}

		if(!isXY(v)) return(nil);

		// We're a leaf node, so we add a new leaf node as a sibling
		// (at the same depth in the tree as us).
		if(isLeafNode())
			return(addLeafNode(v, d));

		// We're not a leaf node, so we pick one of our branches and
		// hand the problem off to them.
		if((b = findBranch(v)) != nil)
			return(b.insert(v, d));

		// Should never happen.
		return(nil);
	}

	// Add a new leaf node for the given data record.
	// The new node will be our sibling, at the same depth in the tree
	// as we are (this is one of the things, along with the split
	// logic, that makes the tree self-balancing)
	addLeafNode(v, d) {
		local obj;

		// Create a new node and set its data record and bounding
		// box.
		obj = new RTree();
		obj.data = d;
		obj.setBoundingBox(v);

		// If we're the root node, we add the leaf node directly
		// to ourselves.  This is the special case of when
		// the tree is otherwise empty, because addLeafNode()
		// is only ever called BY a leaf node, and the root node
		// is only a leaf node if there are no other nodes in
		// the tree.
		// This is the exception to the "leaf nodes are always
		// added as siblings" rule;  in this case we're turning
		// a single node into a tree instead of adding a sibling
		// to the lone node.
		if(isRootNode()) {
			addNode(obj);
		} else {
			// In all other cases we add the new node to
			// our parent, which means the new node is now
			// our sibling.
			prev.addNode(obj);
		}
	}

	// Locate the best branch to query for the given XY instance.
	findBranch(v) {
		local i, min, pick;

		// If we're a leaf node then we have no branches, so we're
		// (necessarily) the answer to the question being asked.
		if(isLeafNode())
			return(self);

		// First, we see if any of our branches contain the point
		// being queries.  If so, we use it.
		for(i = 1; i <= next.length; i++) {
			//if(next[i].contains(v))
			if(next[i].overlaps(v))
				return(next[i]);
		}

		// If we've reached this point, none of the branches
		// contain the ordered pair we care about.
		// Our next guess is then to pick the branch that would
		// have to be expanded the least in order to include
		// the given point.

		pick = nil;	// branch with the minimum distance
		min = nil;	// the minimum distance

		// Traverse the list of branches...
		next.forEach(function(o) {
			local d;

			// ...making sure we can compute the Manhattan
			// distance to the point...
			//if((d = o.manhattanDistance(v)) == nil) return;

			// ...computing the area of the branch expanded
			// to include the new data point.
			if((d = o.areaWith(v)) == nil) return;

			d = d - o.area;

			// ...and remembering this branch if it's the
			// smallest increase we've seen.
			if((min == nil) || (min > d)) {
				min = d;
				pick = o;
			}
		});

		// Return the branch we picked above.
		return(pick);
	}

	// Split branches across multiple nodes.
	// This happens when we add a branch to a node and it exceeds
	// maxBranches.
	// This is a wrapper around another method to make it slightly
	// easier to make subclasses with different split strategies.
	//split() { return(orderedSplit()); }
	split() { return(minAreaSplit()); }

	// Simple splitting strategy based on picking the widest axis
	// of the bounding box and splitting along it, ordering the
	// bounding boxes of the branches along it, and splitting the
	// first half from the second half.
	// This is probably fine for random-ish distributions but
	// spatially inefficient for real-world data.  Simple illustration:
	// If the data is linear and looks like:
	//
	//	..x...x..x...x...x...x..x.x...
	//
	// Then grouping them as:
	//
	//	.[x...x..x...x].[x...x..x.x]..
	//
	// ...works pretty well.  But if it looks like:
	//
	//	..x.x.............x.x..xx.x.x.
	//
	// ...you end up with:
	//
	//	.[x.x.............x.x][xx.x.x]
	//
	orderedSplit() {
		local bb, l;

		// First we get our bounding box.
		bb = getBoundingBox();

		// We pick the axis we're widest along and then
		// sort all the branches by their ordering on that axis.
		if(bb.width > bb.height) {
			l = next.sort(true,
				{ a, b: a.getBoundingBox().upperLeft.x
					- b.getBoundingBox().upperLeft.x });
		} else {
			l = next.sort(true,
				{ a, b: a.getBoundingBox().upperLeft.y
					- b.getBoundingBox().upperLeft.y });
		}

		// Punt to the appropriate method.
		if(isRootNode())
			_orderedSplitRootNode(l);
		else
			_orderedSplitBranchNode(l);
	}

	// Handle an ordered split in the root node.  This has to be
	// handled as a special case because this is how the overall
	// tree grows taller:  the root node can't have siblings, so
	// it goes from having n children (where n is >= maxBranches)
	// to having two children, each with ~(maxBranches / 2) children.
	_orderedSplitRootNode(lst) {
		local i, lf0, lf1, n;

		// Create the two new nodes that will end up with all
		// the branches.
		lf0 = new RTree();
		lf1 = new RTree();

		// Clear our own list of branches.
		next = nil;

		// Half the branch list.
		n = lst.length / 2;

		// Go through all the branches.
		for(i = 1; i <= lst.length; i++) {
			// Half of the branches go to one node, half to the
			// other.
			if(i < n)
				lf0.addNode(lst[i]);
			else
				lf1.addNode(lst[i]);
		}

		// Should be unneccessary.
		setBoundingBox(lf0.getBoundingBox());

		// Add the two new nodes to our branch list.
		addNode(lf0);
		addNode(lf1);
	}

	// Do an ordered split on a branch node.
	_orderedSplitBranchNode(lst) {
		local i, lf, n;

		// Create our new sibling.
		lf = new RTree();

		// Clear our branch list and bounding box.
		next = nil;
		_boundingBox = nil;

		// Half the branch list.
		n = lst.length / 2;

		// Give ourselves the first half of the branches, our
		// new sibling the other half.
		for(i = 1; i <= lst.length; i++) {
			if(i < n)
				addNode(lst[i]);
			else
				lf.addNode(lst[i]);
		}

		// Add our sibling to our parent's branch list.
		prev.addNode(lf);
	}

	// Node splitting logic based on minimizing the area of the
	// bounding box at each insert.
	minAreaSplit() {
		local bb, b0, b1, l;

		// Get the bounding box.
		bb = getBoundingBox();

		// Figure up which is the longest axis of the bounding
		// box and order the branches along that axis.
		if(bb.width > bb.height) {
			l = next.sort(true,
				{ a, b: a.getBoundingBox().upperLeft.x
					- b.getBoundingBox().upperLeft.x });
		} else {
			l = next.sort(true,
				{ a, b: a.getBoundingBox().upperLeft.y
					- b.getBoundingBox().upperLeft.y });
		}

		// Pick the two branches at the far ends of the axis.
		b0 = l[1];
		b1 = l[l.length];

		// Do the split.
		if(isRootNode())
			_minAreaSplitRootNode(l, b0, b1);
		else
			_minAreaSplitBranchNode(l, b0, b1);
	}

	_minAreaSplitRootNode(lst, b0, b1) {
		local a0, a1, i, n0, n1;

		// Create two new nodes.
		n0 = new RTree();
		n1 = new RTree();

		// Add the seed branches to each.
		n0.addNode(b0);
		n1.addNode(b1);

		// Clear our own branch list.
		next = nil;

		// Iterate over all branches except for the seed branches.
		for(i = 2; i <= (lst.length - 1); i++) {
			// Get the area each of the new nodes would
			// have if the branch under consideration was added
			// to it.
			a0 = n0.getBoundingBox()
				.areaWith(lst[i].getBoundingBox());
			a1 = n1.getBoundingBox()
				.areaWith(lst[i].getBoundingBox());

			// Add the branch to the node that will grow the
			// least when it's added.
			if(a0 > a1) {
				n1.addNode(lst[i]);
			} else {
				n0.addNode(lst[i]);
			}
		}

		// Not really needed.
		setBoundingBox(n0.getBoundingBox());

		// Add the new branches to ourselves.
		addNode(n0);
		addNode(n1);
	}

	_minAreaSplitBranchNode(lst, b0, b1) {
		local a0, a1, i, n1;

		// The new sibling node.
		n1 = new RTree();

		// Clear our branch list and bounding box.
		next = nil;
		_boundingBox = nil;

		// Add one seed node to ourselves.
		addNode(b0);

		// Add the other to the new node.
		n1.addNode(b1);

		// Iterate over all the branches except the seed branches.
		for(i = 2; i <= (lst.length - 1); i++) {
			// Get the area of the bounding box if the branch
			// being considered was added to it.
			a0 = getBoundingBox().areaWith(lst[i].getBoundingBox());
			a1 = n1.getBoundingBox().areaWith(lst[i]
				.getBoundingBox());

			// Add the branch to the node that grows the least
			// when it's added.
			if(a0 > a1) {
				n1.addNode(lst[i]);
			} else {
				addNode(lst[i]);
			}
		}

		// Add our new sibling to our parent node.
		prev.addNode(n1);
	}

	// Delete the node at (x, y) with data record d.
	// Note that multiple nodes can occupy the same coordinate, so
	// both a location and data record are needed.
	delete(x, y, d?) {
		local n, r, v;

		if(isXY(x)) {
			v = x;
			d = y;
		} else {
			v = new XY(x, y);
		}

		if((r = _query(v)) == nil)
			return(nil);

		if((n = r.valWhich({ x: x.data == d })) == nil)
			return(nil);

		n._delete();

		return(true);
	}

	// Internal method that actually deletes this node.
	_delete() {
		// Remove our reference to the data record.
		if(data != nil)
			data = nil;

		// If we have branches, delete them as well.
		if(next != nil)
			next.forEach({ x: x._delete() });

		// If we have a parent, ping them to remove us.
		if(prev != nil)
			prev.removeBranch(self);
	}

	// Remove the given branch from this node.
	removeBranch(n) {
		local idx;

		// Validate the argument.
		if(!isRTree(n)) return(nil);
		if(next == nil) return(nil);
		if((idx = next.indexOf(n)) == nil) return(nil);

		// Remove the branch.
		next.removeElementAt(idx);

		// If that was our last branch, delete ourselves as well.
		// Otherwise we need to recompute our bounding box.
		if(next.length < 1) {
			_delete();
		} else {
			recomputeBoundingBox();
		}

		return(true);
	}

	// Recompute the size of our bounding box from the bounding
	// boxes of our branches.
	recomputeBoundingBox() {
		local i;

		// We can't recompute the size of a leaf node's
		// bounding box.
		if(isLeafNode())
			return(nil);

		// Clear the existing bounding box.
		_boundingBox = nil;

		// If we're here, we're a branch node.  If we don't have
		// any branches, we have nothing to compute.
		if((next == nil) || (next.length < 1))
			return(nil);

		// Build our bounding box from our branches.
		// First, just set it to be the first branch's bounding
		// box.
		setBoundingBox(next[1].getBoundingBox());

		// Expand our bounding box to include all our branches'
		// bounding boxen.
		for(i = 2; i <= next.length; i++)
			expand(next[i].getBoundingBox());

		// If we changed, our parent changed.
		if(prev)
			prev.recomputeBoundingBox();

		return(true);
	}

	// Returns the nodes for the given location on success and an
	// empty list if there are none.
	_query(x, y?) {
		local v, r;

		if(isXY(x))
			v = x;
		else if(isRectangle(x))
			v = x;
		else
			v = new XY(x, y);

		if((_boundingBox == nil) || !_boundingBox.overlaps(v))
			return([]);

		// If we're a leaf node we return our data.
		if(isLeafNode()) {
			// Make sure the query is a match.
			if(overlaps(v))
				return(self);
			return([]);
		}

		// Results vector.
		r = new Vector();

		// Traverse all branches, appending any query results they
		// return to the results vector.
		next.forEach({ x: r.appendUnique(x._query(v)) });

		// Convert the results vector to a list and return it.
		return(r.toList());
	}

	// Wrapper for the internal _query() method that returns a list
	// of data records instead of a list of nodes.
	query(x, y?) {
		local l, r;

		if((l = _query(x, y)) == nil) return(nil);
		r = new Vector(l.length());
		l.forEach({ x: r.appendUnique(x.data) });
		return(r.toList());
	}

	// Stub for debugging.
	rTreeDebug(d?) {}
	rTreeDebugBoundingBox() {}
;


#ifdef __DEBUG

modify RTree
	// Debugging-only method that displays the layout of the R-tree.
	// Mostly useful for visually checking to make sure it's balancing
	// correctly.
	rTreeDebug(d?) {
		local indent;

		if(d == nil) d = 0;
		indent = new Vector(d);
		indent.fillValue('\t', 1, d);
		indent = indent.join('');

		"\n<<indent>><<(isLeafNode() ? 'leaf' : 'branch')>> node ";

		if(isLeafNode()) {
			"with data <q><<toString(data)>></q>\n ";
			return;
		}
		"with <<toString(next.length)>> branches:\n ";
		next.forEach({ x: x.rTreeDebug(d + 1) });
	}

	rTreeDebugBoundingBox() {
		local bb;

		bb = getBoundingBox();
		"\nbounding box: <<bb.corner0.toStr()>> ";
		"<<bb.corner1.toStr()>>\n ";
		if(next == nil) return;

		next.forEach(function(o) {
			local b2;

			b2 = o.getBoundingBox();
			"\n\t<<b2.corner0.toStr()>> <<b2.corner1.toStr()>>\n ";
		});
	}
;

#endif // __DEBUG

#endif // USE_XY
