#charset "us-ascii"
//
// propTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the finiteStateMachine
// library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f propTest.t3m
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
		local obj0, obj1;

		obj0 = object { foo = 1 bar = 2};
		obj1 = object { foo = nil };
		obj1.copyProps(obj0);
		"\nfoo = <<toString(obj1.foo)>>\n ";
		"\nbar = <<toString(obj1.bar)>>\n ";

		obj0 = object { foo = 1 bar = 2};
		obj1 = object { foo = nil };
		obj0.copyProps(obj1);
		"\nfoo = <<toString(obj0.foo)>>\n ";
		"\nbar = <<toString(obj0.bar)>>\n ";
	}
;
