#charset "us-ascii"
//
// graphInit.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataStructures.h"

graphInit: InitObject
	execute() {
		forEachInstance(Vertex, { x: x.initializeVertex() });
		forEachInstance(Edge, { x: x.initializeEdge() });
		forEachInstance(Graph, { x: x.initializeGraph() });
	}
;
