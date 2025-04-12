#charset "us-ascii"
//
// rTreeDeleteTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// Test of the R-tree node deletion logic.
//
// It can be compiled via the included makefile with
//
//	# t3make -f rTreeDeleteTest.t3m
//
// ...or the equivalent, depending on what TADS development environment
// you're using.
//
// This "game" is distributed under the MIT License, see LICENSE.txt
// for details.
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

versionInfo: GameID;
gameMain: GameMainDef
	// To hold the R-tree
	_tree = nil

	// Number of nodes to create/test.
	nodes = 40

	newGame() {
		createTree();

		if(!runTests())
			"\nERROR:  encountered one or more errors\n ";
		else
			"\npassed all tests\n ";
	}

	createTree() {
		local i;

		// Create the tree.
		_tree = new RTree();

		// Add a bunch of nodes.  The nth node has coordinates
		// (n, n) and the name "foo[n]".
		for(i = 0; i < nodes; i++) {
			_tree.insert(i, i,
				'foo' + toString(i));
		}

		// Same as above, only with "bar" instead of "foo".
		for(i = 0; i < nodes; i++) {
			_tree.insert(i, i,
				'bar' + toString(i));
		}
	}

	runTests() {
		return(singleDeleteTest() && bigDeleteTest() && restoreTest());
	}

	// Delete the "foo1" record at (1, 1).
	singleDeleteTest() {
		local ar;

		ar = _tree.query(1, 1);
		_tree.delete(1, 1, 'foo1');

		ar = _tree.query(1, 1);

		if((ar == nil) || (ar.length != 1)
			|| ar[1] != 'bar1') {
			"\nERROR:  delete test failed\n ";
			return(nil);
		}

		// Re-insert the deleted record.
		_tree.insert(1, 1, 'foo1');

		return(true);
	}

	// Delete a whole bunch of nodes, enough that recursive pruning
	// must take place.
	bigDeleteTest() {
		local ar, err, i;

		// Delete all the "bar" records.
		for(i = 0; i < nodes; i++) {
			_tree.delete(i, i,
				'bar' + toString(i));
		}

		// Delete all the "foo" records that are multiples of 2 or 3.
		for(i = 0; i < nodes; i++) {
			if(!(i % 2) || !(i % 3))
				_tree.delete(i, i,
					'foo' + toString(i));
		}

		err = 0;

		// Make sure all the right records were delete AND that
		// all the records that weren't supposed to be deleted
		// are still there.
		for(i = 0; i < nodes; i++) {
			if(!(i % 2) || !(i % 3))
				continue;
			ar = _tree.query(i, i);
			if((ar == nil) || (ar.length != 1)) {
				err += 1;
				continue;
			}
			if(ar[1] != 'foo' + toString(i)) {
				err += 1;
				continue;
			}
		}

		if(err != 0) {
			"\nERROR:  got <<toString(err)>> failures in big ";
			"delete test\n ";
			return(nil);
		}

		return(true);
	}

	// Re-add all the records we deleted in the previous test, and then
	// verify that querying them works correctly.
	restoreTest() {
		local ar, err, i;

		// Re-add all the "bar" records.
		for(i = 0; i < nodes; i++) {
			_tree.insert(i, i,
				'bar' + toString(i));
		}

		// Re-add all the "foo" records that are multiples of 2 or 3.
		for(i = 0; i < nodes; i++) {
			if(!(i % 2) || !(i % 3))
				_tree.insert(i, i,
					'foo' + toString(i));
		}

		err = 0;

		// This should work the same as the basic test in
		// rTreeTest.t, because all the deleted records should
		// now be restored.
		for(i = 0; i < nodes; i++) {
			ar = _tree.query(i, i);
			if((ar == nil) || (ar.length != 2)) {
				err += 1;
				continue;
			}
			if((ar.indexOf('foo' + toString(i)) == nil)
				|| (ar.indexOf('bar' + toString(i)) == nil)) {
				err += 1;
				continue;
			}
		}

		if(err != 0) {
			"\nERROR:  got <<toString(err)>> failures in restore ";
			"test\n ";
			return(nil);
		}

		return(true);
	}

	query(x, y) {
		local d, v;

		v = new XY(x, y);
		d = _tree.query(v);
		aioSay('\n@<<v.toStr()>>: ');
		if(d == nil) {
			aioSay('nil\n ');
			return;
		}
		d.forEach({ x: aioSay('<<toString(x)>> ') });
		aioSay('\n ');
	}
;
