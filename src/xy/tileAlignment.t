#charset "us-ascii"
//
// tileAlignment.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

#ifdef USE_XY

class TileAlignment: object
	_tileBoundingBox = nil
	tileBoundingBoxClass = IntegerMatrix

	_tiles = nil

	initTileBoundingBox(x, y?) {
		local v;
		if(isXY(x)) v = x;
		else v = new XY(x, y);
		return(_tileBoundingBox
			= tileBoundingBoxClass.createInstance(v.x, v.y));
	}
	getTileBoundingBox() { return(_tileBoundingBox); }
	setTileBoundingBox(v) {
		return(isType(v, tileBoundingBoxClass)
			&& ((_tileBoundingBox = v) != nil));
	}
	clearTileBoundingBox() { _tileBoundingBox = nil; }

	addTile(v?) {
		local bb;

		if(!isTile(v)) return(nil);
		if(_tiles == nil) _tiles = new Vector();
		if((bb = getTileBoundingBox()) == nil)
			initTileBoundingBox(v.corner0, v.corner1);
		bb.expand(v);
		_tiles.appendUnique(v);

		return(true);
	}
	getTiles() { return(_tiles); }
	setTiles(v) { return(isVector(v) && ((_tiles = v) != nil)); }
	clearTiles() { _tiles = nil; }
;

#endif // USE_XY
