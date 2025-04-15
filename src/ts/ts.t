#charset "us-ascii"
//
// ts.t
//
//	Simple wall clock timestamp mechanism.
//
//
// USAGE
//
//	The class constructor saves the instance's creation time and
//	subsquent calls to TS.getInterval() will report the number of
//	seconds since the instance's creation.
//
//		// Create an instance
//		local ts = new TS();
//
//		[ stuff ]
//
//		// t will contain the decimal seconds since ts was created.
//		local t = ts.getInterval();
//
//
#include <adv3.h>
#include <en_us.h>

#include <date.h>
#include <bignum.h>

#include "dataTypes.h"

class TS: object
	ts = nil

	construct() { ts = new Date(); }

	getInterval(d?) {
		if((d == nil) || !d.ofKind(Date)) d = new Date();
		return(((d - ts) * 86400).roundToDecimal(5));
	}
;
