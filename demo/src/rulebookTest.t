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

versionInfo: GameID;
gameMain: GameMainDef
	newGame() {
		"Default:\n ";
		defaultRulebook.log('nil');
		defaultRule1.foozle = true;
		defaultRulebook.log('true');

		"<.p>Any:\n ";
		anyRulebook.log('nil');
		anyRule2.foozle = true;
		anyRulebook.log('true');
		anyRule1.foozle = true;
		anyRulebook.log('true');
		anyRule1.foozle = nil;
		anyRule2.foozle = nil;
		anyRulebook.log('nil');

		"<.p>None:\n ";
		noneRulebook.log('true');
		noneRule1.foozle = true;
		noneRulebook.log('nil');
		noneRule2.foozle = true;
		noneRulebook.log('nil');
		noneRule1.foozle = nil;
		noneRule2.foozle = nil;
		noneRulebook.log('true');
	}
;

class TestRulebook: Rulebook
	log(txt) {
		"<<txt>>: <<toString(eval())>>\n ";
	}
;

class DefaultRule: Rule
	foozle = nil
	match(data?) { return(foozle == true); }
;

defaultRulebook: TestRulebook;
+defaultRule1: DefaultRule 'default1';
+defaultRule2: DefaultRule 'default2' foozle = true;

anyRulebook: TestRulebook, RulebookMatchAny;
+anyRule1: DefaultRule 'any1';
+anyRule2: DefaultRule 'any2';

noneRulebook: TestRulebook, RulebookMatchNone;
+noneRule1: DefaultRule 'none1';
+noneRule2: DefaultRule 'none2';
