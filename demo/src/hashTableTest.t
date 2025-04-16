#charset "us-ascii"
//
// hashTableTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// Simple test of the basic functionality of the HashTable class.
//
// It can be compiled via the included makefile with
//
//	# t3make -f hashTableTest.t3m
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
	newGame() {
		local l, t, v0, v1;

		t = new HashTable();

		v0 = new Foo('bar');
		v1 = new Foo('baz');

		t.insert('foo', v0);
		t.insert('foo', v1);

		if((l = t.query('foo')) == nil) {
			"\nERROR:  query failed\n ";
			return;
		}
		if(l.length != 2) {
			"\nERROR:  got wrong number of query results\n ";
			return;
		}
		if((l.subset({ x: (x.query() == 'bar') }).length != 1) ||
			(l.subset({ x: (x.query() == 'baz') }).length != 1)) {
			"\nERROR:  query returned bogus results\n ";
			return;
		}

		t.delete('foo', v0);
		if((l = t.query('foo')) == nil) {
			"\nERROR:  query failed after delete\n ";
			return;
		}
		if(l.length != 1) {
			"\nERROR:  got wrong number of query results ";
			"after delete\n ";
			return;
		}
		if(l.subset({ x: (x.query() == 'baz') }).length != 1) {
			"\nERROR:  query returned bogus results ";
			"after delete\n ";
			return;
		}

		"\npassed all tests\n ";
	}
;

class Foo: object
	someProp = nil
	construct(v?) { someProp = v; }
	query() { return(someProp); }
;
