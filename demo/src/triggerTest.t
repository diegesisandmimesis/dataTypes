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

#include "dataTypes.h"

versionInfo: GameID;
gameMain: GameMainDef
	initialPlayerChar = me
	newGame() {
		"This demo includes a Trigger that matches when the
		action is <b>&gt;TAKE PEBBLE</b> and me.afterAction()
		reports on whether or not it matches this turn.<.p>\n ";
		runGame(true);
	}
;

startRoom: Room 'Void'
	"This is a featureless void. "
;
+pebble: Thing '(small) (round) pebble' 'pebble' "A small, round pebble. ";
+me: Person
	afterAction() {
		if(trigger.match())
			extraReport('The action is &gt;TAKE PEBBLE. ');
		else
			extraReport('The action is not &gt;TAKE PEBBLE. ');
	}
;

trigger: Trigger
	srcActor = me
	dstObject = pebble
	action = TakeAction
;
