#charset "us-ascii"
//
// ac3Tests3.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// It can be compiled via the included makefile with
//
//	# t3make -f ac3Tests3.t3m
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
		local g, l, str;

		g = new AC3();

		l = [ 'asparagus', 'broccoli', 'carrots', 'daikon' ];

		// Alice likes all the vegetables.
		g.addVariable('Alice', new Vector(l));

		// Bob can't handle broccoli.
		g.addVariable('Bob',
			new Vector(l).subset({ x: x != 'broccoli' }));

		// Carol also likes all vegetables.
		g.addVariable('Carol', new Vector(l));

		// Alice and Bob want to have the same thing.
		g.addConstraint('Alice', 'Bob', { a, b: a == b });

		// Alice and Carol never have the same thing.
		g.addConstraint('Alice', 'Carol', { a, b: a != b });

		local r = g.getSolutions();
		if(r == nil) {
			"\nERROR:  no solution\n ";
			return;
		}
		str = new StringBuffer();
		r.forEach(function(x) {
			x.forEachAssoc({ k, v: str.append('<<toString(k)>> has
				<<toString(v)>>. ') });
			str.append('\n');
		});
		"\n<<toString(str)>>\n ";
	}
;
