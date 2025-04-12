#charset "us-ascii"
//
// rTreeQueryTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// Test of non-point queries.
//
// It can be compiled via the included makefile with
//
//	# t3make -f rTreeQueryTest.t3m
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
		local err, i;

		createTree();

		err = 0;
		for(i = 2; i < nodes; i++) {
			if(!queryRect(rand(i - 1), i))
				err += 1;
		}

		if(err == 0)
			"\npassed all tests\n ";
		else
			"\nFAILED <<toString(err)>> random queries\n ";
	}

	queryRect(n, m) {
		local i, l, r;

		l = _tree.query(new Rectangle(n, n, m, m));
		r = new Vector(l.length());

		for(i = n; i <= m; i++) {
			r.append('foo' + toString(i));
			r.append('bar' + toString(i));
		}

		if(l.length != r.length)
			return(nil);

		for(i = 1; i <= r.length; i++) {
			if(l.indexOf(r[i]) == nil)
				return(nil);
		}

		for(i = 1; i <= l.length; i++) {
			if(r.indexOf(l[i]) == nil)
				return(nil);
		}
		return(true);
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
		return(basicTest());
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
