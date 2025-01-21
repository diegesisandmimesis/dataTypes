#charset "us-ascii"
//
// graphInit.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

// Preinit is for "short form" graph declarations--where everything
// is part of the graph declaration itself (as opposed to +Vertex
// declarations and so on)
graphPreinit: PreinitObject
	execute() {
		forEachInstance(Graph, { x: x.preinitGraph() });
	}
;

// Handle "long form" graph declarations--where you have a Graph
// declaration followed by +Vertex and/or +Edge declarations.
graphInit: InitObject
	execute() {
		forEachInstance(Vertex, { x: x.initializeVertex() });
		forEachInstance(Edge, { x: x.initializeEdge() });
		forEachInstance(Graph, { x: x.initializeGraph() });
	}
;
