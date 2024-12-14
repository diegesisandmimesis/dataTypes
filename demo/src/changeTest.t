#charset "us-ascii"
//
// changeTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the finiteStateMachine
// library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f changeTest.t3m
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
	newGame() {
		"Foozle.\n ";
		"\nfoozle = <<toString(foozleID())>>\n ";
		foozleFSM.setState('bar');
		"\nfoozle = <<toString(foozleID())>>\n ";
		foozleFSM.toState('baz');
		"\nfoozle = <<toString(foozleID())>>\n ";
	}
;

DefineFSM(foozle, [ 'foo', 'bar', 'baz' ]);
+Transition 'foo' 'bar';
+Transition 'bar' 'baz';
