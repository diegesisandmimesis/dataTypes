#charset "us-ascii"
//
// rTreeTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// Test of the R-tree logic.
//
// Adds a bunch of data points with predictable names and locations,
// including spatial overlaps, and then queries all of them and reports
// any misses.
//
// A test of minimal functionality, should never fail.
//
// It can be compiled via the included makefile with
//
//	# t3make -f rTreeTest.t3m
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
		return(basicTest() && emptyTest());
	}

	basicTest() {
		local ar, err, i;

		// Start out with no errors.
		err = 0;

		// Go through the same number of nodes, querying the
		// location where each should be and making sure that
		// the query results are exactly the corresponding
		// "foo" and "bar".
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
			"\nERROR:  got <<toString(err)>> failures querying ";
			"existing records\n ";
			return(nil);
		}

		return(true);
	}

	emptyTest() {
		local ar, err, i;

		err = 0;

		for(i = nodes; i < (nodes * 2); i++) {
			ar = _tree.query(i, i);
			if((ar == nil) || (ar.length != 0))
				err += 1;
		}

		if(err != 0) {
			"\nERROR:  got <<toString(err)>> failure querying ";
			"empty records\n ";
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
