#charset "us-ascii"
//
// gTupleTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the finiteStateMachine
// library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f gTupleTest.t3m
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

versionInfo: GameID;
gameMain: GameMainDef
	initialPlayerChar = me
	newGame() {
		"\nIn this demo the player object has beforeAction() and
		afterAction() methods that should output the value of gTuple
		and gNestedTuple every turn.<.p>
		Something to try is <b>&gt;TAKE PEBBLE FROM BOX</b> to
		see how the two different actions (TakeFrom and Take) look
		in the before and after methods.<.p>\n ";
		runGame(true);
	}
;

function _debugObject(obj, lbl?) {
	if(obj == nil) return;
	aioSay('\n===<<(lbl ? lbl : toString(obj))>> start===\n ');
	obj.getPropList().sort(nil,
		{ a, b: toString(a).compareTo(toString(b)) })
		.forEach(function(o) {
			if(!obj.propDefined(o, PropDefDirectly)) return;
			aioSay('\n\t<<toString(o)>>:
				<<toString((obj).(o))>>\n ');
	});
	aioSay('\n===<<(lbl ? lbl : toString(obj))>> end===\n ');
}

class Pebble: Thing '(small) (round) pebble' 'pebble'
	"A small, round pebble. "
	isEquivalent = true
;

startRoom: Room 'Void'
	"This is a featureless void. "
;
+me: Person
	beforeAction() {
		local t;

		aioSay('\n===BEFORE ACTION start===\n ');
		t = gTuple();
		_debugObject(t, 'gTuple');
		"<.p>\n ";
		t = gNestedTuple();
		_debugObject(t, 'gNestedTuple');
		aioSay('\n===BEFORE ACTION end===\n ');
	}
	afterAction() {
		local t;

		aioSay('\n===AFTER ACTION start===\n ');
		t = gTuple();
		_debugObject(t);
		"<.p>\n ";
		t = gNestedTuple();
		_debugObject(t);
		aioSay('\n===AFTER ACTION end===\n ');
	}
;
+box: Container '(wooden) box' 'box' "It's a wooden box. ";
++pebble1: Pebble;
+pebble2: Pebble;
