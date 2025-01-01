#charset "us-ascii"
//
// rulebookTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the finiteStateMachine
// library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f rulebookTest.t3m
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

pebble: Thing '(small) (round) pebble' 'pebble' "A small, round pebble. ";
foo: object;

versionInfo: GameID;
gameMain: GameMainDef
	tests = 0
	failures = 0
	results = perInstance(new Vector())


	// All we're doing here is testing whether the default/"all", "any",
	// and "none" rulebook types work.  We do this using one rulebook
	// of each type, each of which includes rules that match or don't
	// match entirely based on their "foozle" property.
	newGame() {
		local i;

		// Test the default, which is "match all"
		// We start with one rule true and one false, so by default
		// the rulebook should be false.
		_runTest(defaultRulebook, nil);
		// Set the other rule true, and both should be true and
		// so the rulebook should also be true.
		defaultRule1.foozle = true;
		_runTest(defaultRulebook, true);

		// Test "match any"
		// We start out with no matches, so the rulebook should be
		// false.
		_runTest(anyRulebook, nil);
		// Mark one rule true, rulebook should now be true.
		anyRule2.foozle = true;
		_runTest(anyRulebook, true);
		// Mark the othe rule true, rulebook should stay true.
		anyRule1.foozle = true;
		_runTest(anyRulebook, true);
		// Now mark both rules false, rulebook should be false.
		anyRule1.foozle = nil;
		anyRule2.foozle = nil;
		_runTest(anyRulebook, nil);

		// "Match none" rulebook
		// We start with no rules true, so rulebook should start true
		_runTest(noneRulebook, true);
		// Mark one rule true, rulebook should now be false
		noneRule1.foozle = true;
		_runTest(noneRulebook, nil);
		// Mark other rule true, rulebook should stay false
		noneRule2.foozle = true;
		_runTest(noneRulebook, nil);
		// Mark both rules nil, rulebook should now be true.
		noneRule1.foozle = nil;
		noneRule2.foozle = nil;
		_runTest(noneRulebook, true);

		if(failures == 0) {
			"Passed all tests\n ";
		} else {
			"FAILED <<toString(failures)>> of <<toString(tests)>>
				test\n ";
			for(i = 1; i <= results.length; i++) {
				if(results[i] != true)
					"\n\tFAILED test <<i>>\n ";
			}
		}
	}

	_runTest(rb, v) {
		tests += 1;
		rb.eval();
		results.append(rb.getValue() == v);
		if(results[results.length] != true)
			failures += 1;
	}
;

class TestRulebook: Rulebook;
// Silly rule whose state is equal to its "foozle" property
class DefaultRule: Rule
	foozle = nil
	match(data?) { return(foozle == true); }
;

// Default rulebook, "match all", starts with one rule true.
defaultRulebook: TestRulebook;
+defaultRule1: DefaultRule 'default1';
+defaultRule2: DefaultRule 'default2' foozle = true;

// "Match any" rulebook, both rules start false.
anyRulebook: TestRulebook, RulebookMatchAny;
+anyRule1: DefaultRule 'any1';
+anyRule2: DefaultRule 'any2';

// "Match none" rulebook, both rules start false.
noneRulebook: TestRulebook, RulebookMatchNone;
+noneRule1: DefaultRule 'none1';
+noneRule2: DefaultRule 'none2';
