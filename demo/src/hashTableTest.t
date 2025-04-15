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
		local l, t;

		t = new HashTable();
		t.insert('foo', new Foo('bar'));
		t.insert('foo', new Foo('baz'));
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
		"\npassed all tests\n ";
	}
;

class Foo: object
	someProp = nil
	construct(v?) { someProp = v; }
	query() { return(someProp); }
;
