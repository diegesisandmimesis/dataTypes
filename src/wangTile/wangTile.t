#charset "us-ascii"
//
// wangTile.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

#ifdef USE_XY

enum wtR, wtG, wtB, wtW;

class WangTile: object
	label = nil
	pattern = nil
;

WangTile 'A' [ wtR, wtG, wtR, wtR ];
WangTile 'B' [ wtB, wtG, wtR, wtB ];
WangTile 'C' [ wtR, wtG, wtG, wtG ];
WangTile 'D' [ wtW, wtB, wtB, wtR ];
WangTile 'E' [ wtB, wtB, wtB, wtW ];
WangTile 'F' [ wtW, wtW, wtW, wtR ];
WangTile 'G' [ wtR, wtW, wtG, wtB ];
WangTile 'H' [ wtB, wtR, wtW, wtB ];
WangTile 'I' [ wtB, wtR, wtR, wtW ];
WangTile 'J' [ wtG, wtR, wtG, wtB ];
WangTile 'K' [ wtR, wtG, wtW, wtR ];

#endif // USE_XY
