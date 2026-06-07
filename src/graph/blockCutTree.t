#charset "us-ascii"
//
// blockCutTree.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

modify Vertex
	// In the block cut tree each vertex in the tree is a block from
	// the graph used to construct the tree.  This property will hold
	// a list containing the vertex IDs of the vertices from the original
	// graph in this block.
	blockCutVertices = nil
;

class BlockCutTree: Graph
	// Boolean, keyed by vertex ID.  Has this vertex been evaluated?
	visited = perInstance(new LookupTable)

	// Integer, keyed by vertex ID.  What is the depth of this vertex
	// relative to the starting vertex?
	depth = perInstance(new LookupTable)

	// Lowpoint, keyed by vertex ID.  What is the minimum distance
	// of this vertex's neighbors?
	lowpoint = perInstance(new LookupTable)

	// Vertex ID, keyed by vertexID.  What is the vertex ID of this
	// vertex?  Specifically in the depth-first search used to construct
	// the tree, not necessarily in the parent graph.
	parent = perInstance(new LookupTable)

	// List of edges identified as cuts, as 2-element vector of
	// vertex IDs.
	articulationPoints = perInstance(new Vector())

	// Edge stack used in figuring out which vertices are in each
	// block.  Elements are 2-element vectors of vertex IDs.
	stack = perInstance(new Vector())

	// List of computed blocks.  Elements are vectors of vertex IDs.
	blocks = perInstance(new Vector())

	// Create the block cut tree for the argument graph.
	// Optional second argument is a flag.  If boolean true, the
	// intermediate data used for the construction won't be freed.
	convert(g, skipCleanup?) {
		local i, l, v;

		if(!isGraph(g))
			return(nil);

		// Make sure we have at least one vertex.
		l = g.getVertices();
		if(l.length < 1)
			return(nil);

		// Call the recursive solver.
		hopcroftTarjan(l[1], 0);

		// Add a vertex to the tree for each block, adding the
		// list of vertex IDs from the parent graph to the
		// vertex.
		for(i = 1; i <= blocks.length; i++) {
			if((v = addVertex('block' + toString(i))) == nil)
				return(nil);

			// Remember the list of vertices.
			v.blockCutVertices = new Vector(blocks[i]);
		}

		// Now iterate over all of the cuts.
		articulationPoints.forEach(function(x) {
			local id;

			// Add a vertex for each cut.
			id = 'cut' + toString(x);
			addVertex(id);

			// Iterate over all the blocks.
			for(i = 1; i <= blocks.length; i++) {
				// Make sure the block includes the cut
				// vertex.
				if(blocks[i].indexOf(x) == nil)
					continue;

				// Add an edge between the cut and the
				// associated block.
				addEdge(id, 'block' + toString(i));
			}
		});

		// By default, free all the scratch data.
		if(skipCleanup != true)
			cleanup();

		return(true);
	}

	// Get rid of all the temporary data.
	cleanup() {
		visited = nil;
		depth = nil;
		lowpoint = nil;
		parent = nil;

		articulationPoints = nil;

		stack = nil;
		blocks = nil;
	}

	// Implementation of the Hopcroft-Tarjan algorithm.
	hopcroftTarjan(v0, d) {
		local blk, children, e, id0, id1, isArticulation;

		id0 = v0.vertexID;

		// Mark this vertex as visited, remember the depth, and
		// set the default lowpoint.
		visited[id0] = true;
		depth[id0] = d;
		lowpoint[id0] = d;

		// This interation currently has no children and we assume
		// it is not an cut point.
		children = 0;
		isArticulation = nil;

		// Iterate over all adjacent vertices.
		v0.getAdjacentVertices().forEach(function(v1) {
			id1 = v1.vertexID;

			if(visited[id1] != true) {
				// Set the parent.
				parent[id1] = id0;

				// Add the edge leading here to the stack.
				stack.push([ id0, id1 ]);

				// Recurse.
				hopcroftTarjan(v1, d + 1);

				// Bump the child count.
				children += 1;

				// If we're lower than our parent, we're
				// a cut point.
				if(lowpoint[id1] >= depth[id0]) {
					isArticulation = true;

					// If we're a cut, we've got a new
					// block.
					blk = new Vector();

					// Go through the edge stack we
					// built through recursion above.
					while(stack.length() > 0) {
						// Add all vertices mentioned
						// in the edge stack to the
						// block.
						e = stack.pop();
						blk.appendUnique(e[1]);
						blk.appendUnique(e[2]);

						// Once we reach our edge,
						// we're done.
						if(((e[1] == id0)
							&& (e[2] == id1))
							|| ((e[1] == id1)
							&& (e[2] == id0)))
							break;
					}

					// Add the block we just created to
					// the list.
					blocks.append(blk);
				}

				// If our low point is lower than our
				// parent's, update it.
				lowpoint[id0] = min(lowpoint[id0],
					lowpoint[id1]);
			} else if(id1 != parent[id0]) {
				// Parent here just means in the depth-first
				// search path (not in the graph).  This
				// is just handling the case where depth-first
				// searching bypassed a sibling vertex, that
				// now needs to be updated.
				if(depth[id0] > depth[id1])
					stack.push([ id0, id1 ]);
				lowpoint[id0] = min(lowpoint[id0], depth[id1]);
			}
		});
		// If we became a cut point through recursion or if we
		// have no parent (i.e., we're the starting vertex) and
		// we have multiple children, add ourselves to the cut point
		// list.
		if(((parent[id0] != nil) && isArticulation)
			|| ((parent[id0] == nil) && (children > 1))) {
			articulationPoints.push(id0);
		}
	}
;
