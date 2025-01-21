#charset "us-ascii"
//
// graphSubgraph.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

modify Graph
	generateSubgraphs() {
		local i, l, r, u, vv, v0, v1;

		// Return value.
		r = new Vector();

		// Unchecked vertices.  These are the vertices we don't
		// know which subgraph they belong to yet.
		// We start out with every vertex unchecked.
		l = new Vector(_vertexTable.valsToList());

		// "Unvisited" vertices.  These are in whatever subgraph
		// we're working on, but we haven't checked their edges
		// yet.
		u = new Vector();

		while(l.length > 0) {
			// Add a new vector to the return vector.  We'll
			// add all the vertices in the current subgraph
			// to the new vector.
			r.append(new Vector());

			vv = l[1];
			u.setLength(0);
			u.append(vv);

			// Now we iterate while we have unchecked vertices
			// in the current subgraph.
			while(u.length > 0) {
				v0 = u[1];
				// Iterate over all the edges on the
				// next unchecked vertex.
				v0._edgeTable.valsToList().forEach(
					function(e) {
						// Figure out which end is
						// the other end.
						if(e.vertex0 == v0)
							v1 = e.vertex1;
						else
							v1 = e.vertex0;

						// If we don't have the other
						// vertex in our subgraph
						// already, add it to the
						// unvisited list.
						if(r[r.length].indexOf(v1)
							== nil)
							u.append(v1);

						// Remove the other vertex from
						// the unchecked list.
						if((i = l.indexOf(v1)) != nil)
							l.removeElementAt(i);
					}
				);

				// If we haven't already added this vertex
				// to the subgraph, do so now.
				if(r[r.length].indexOf(v0) == nil)
					r[r.length].append(v0);

				// Remove the vertex we just checked.
				u.removeElementAt(1);
			}

			// Remove the vertex we just handled.
			if((i = l.indexOf(vv)) != nil)
				l.removeElementAt(i);
		}

		// Return our results.
		return(r);
	}
;
