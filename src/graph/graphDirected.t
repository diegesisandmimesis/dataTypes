#charset "us-ascii"
//
// graphDirected.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

class DirectedGraph: Graph
	edgeClass = DirectedEdge
	directed = true
;

class DirectedEdge: Edge
	directed = true
;
