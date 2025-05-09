#charset "us-ascii"
//
// tile.t
//
//	Tile class.  In our usage a tile is just a rectangle for which
//	you can define points of alignment along its perimeter.
//
//	This is for things like board game tiles that can be arranged
//	in various ways but you have to line up the doorways, or
//	something like that.
//
//	In our case we call the alignment points "contacts", which
//	are just XY instances that lie along the rectangle's perimeter.
//	We also provide some methods for interacting with them.  Actual
//	alignment of multiple tiles is left to the TileAlignment mixin
//	class.
//
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

#ifdef USE_XY

class Tile: Rectangle
	// Vector for our contacts.
	contacts = nil

	// Returns boolean true if the coordinate lies on our perimeter.
	onPerimeter(v) {
		if(!isXY(v)) return(nil);
		if(((v.y == corner0.y) || (v.y == corner1.y))
			&& inRange(v.x, corner0.x, corner1.x))
			return(true);
		if(((v.x == corner0.x) || (v.x == corner1.x))
			&& inRange(v.y, corner0.y, corner1.y))
			return(true);
		return(nil);
	}

	addContact(v) {
		if(!onPerimeter(v)) return(nil);
	
		if(contacts == nil) contacts = new Vector();
		if(contacts.subset({ x: x.equals(v) }).length > 0)
			return(nil);
		contacts.append(v);
		return(true);
	}
	getContacts() { return(contacts ? contacts : []); }

	removeContact(v) {
		if(contacts == nil) return(nil);
		if(contacts.subset({ x: x.equals(v) }).length() != 1)
			return(nil);
		contacts = contacts.subset({ x: !x.equals(v) });
		return(true);
	}
;

#endif // USE_XY
