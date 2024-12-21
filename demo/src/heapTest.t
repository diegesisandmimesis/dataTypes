#charset "us-ascii"
//
// heapTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the finiteStateMachine
// library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f heapTest.t3m
//
// ...or the equivalent, depending on what TADS development environment
// you're using.
//
// This "game" is distributed under the MIT License, see LICENSE.txt
// for details.
//
#include <adv3.h>
#include <en_us.h>

#include "dataStructures.h"

#include "intMath.h"
#ifndef INT_MATH_H
#error "This demo requires the intMath module."
#error "https://github.com/diegesisandmimesis/intMath"
#error "It should be in the same parent directory as this module.  So if"
#error "dataStructures is in /home/user/tads/dataStructures, then"
#error "intMath should be in /home/user/tads/intMath ."
#endif // INT_MATH_H

versionInfo: GameID;
gameMain: GameMainDef
	// Array to generate permute
	testData = static [ 'foo', 'bar', 'baz' ]

	newGame() {
		local lst, r, t;

		// Get the permutations of the test data.
		lst = permutations(testData);

		// Generate a unique array of the sorted forms of
		// the permuations.  This should be exactly one element
		// long, as all the permuations should be the same except
		// for order.
		r = new Vector(testData.length);
		lst.forEach({
			// IMPORTANT:  need to create new Vector before
			//	sort.
			x: r.appendUnique(toString(new Vector(x).sort()))
		});

		if(r.length != 1) {
			"FAILED:  got non-permutation\n ";
			return;
		}

		// Now generate a list of each unique element of the permutation
		// array.
		r.setLength(0);
		lst.forEach({ x: r.appendUnique(toString(x)) });

  		// If the length of the uniq-ified array isn't the same as the
		// number of generated permutations, we got a duplicate
		// somewhere.
		if(lst.length != r.length) {
			"FAILED:  got duplicate permuations\n ";
			"\n\t<<toString(lst)>>\n ";
			"\n\t<<toString(r)>>\n ";
			return;
		}

		// Figure out how many permutations we SHOULD have.
		t = factorial(testData.length);

		if(r.length == t) {
			"Tests passed\n ";
		} else {
			"FAILED:  got <<toString(r.length)>> permutations
				for <<toString(testData.length)>> array,
				needed <<toString(t)>>\n ";
		}
		
	}
;
