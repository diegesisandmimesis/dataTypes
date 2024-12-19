#charset "us-ascii"
//
// triggerTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the finiteStateMachine
// library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f triggerTest.t3m
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
		"\nIn this demo the player object has an afterAction()
		method that should output the value of gTuple every
		turn.<.p>\n ";
		runGame(true);
	}
;

function _debugObject(obj) {
	if(obj == nil) return;
	aioSay('\n===<<toString(obj)>> start===\n ');
	obj.getPropList().sort(nil,
		{ a, b: toString(a).compareTo(toString(b)) })
		.forEach(function(o) {
			if(!obj.propDefined(o, PropDefDirectly)) return;
			aioSay('\n\t<<toString(o)>>:
				<<toString((obj).(o))>>\n ');
	});
	aioSay('\n===<<toString(obj)>> end===\n ');
}

class Pebble: Thing '(small) (round) pebble' 'pebble'
	"A small, round pebble. "
	isEquivalent = true
;

startRoom: Room 'Void'
	"This is a featureless void. "
;
+me: Person
	trigger = nil

	beforeAction() {
		if(trigger == nil) {
			trigger = new Trigger('foo');
			trigger.srcActor = self;
			trigger.dstObject = pebble1;
			trigger.action = TakeAction;
		}
		aioSay('\n===trigger===\n ');
		aioSay('<<toString(trigger.match())>> ');
		aioSay('\n===trigger===\n ');
	}
;
+box: Container '(wooden) box' 'box' "It's a wooden box. ";
++pebble1: Pebble;
+pebble2: Pebble;
