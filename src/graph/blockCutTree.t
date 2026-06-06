#charset "us-ascii"
//
// blockCutTree.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

class BlockCutTree: Graph
	visited = perInstance(new LookupTable)
	depth = perInstance(new LookupTable)
	lowpoint = perInstance(new LookupTable)
	parent = perInstance(new LookupTable)

	articulationPoints = perInstance(new Vector())

	stack = perInstance(new Vector())
	blocks = perInstance(new Vector())

	convert(g) {
		local i, l, v;

		if(!isGraph(g))
			return(nil);

		l = g.getVertices();
		if(l.length < 1)
			return(nil);

		recurse(l[1], 0);

		for(i = 1; i <= blocks.length; i++) {
			if((v = addVertex('block' + toString(i))) == nil)
				return(nil);
			v.data = new Vector(blocks[i]);
		}
		articulationPoints.forEach(function(x) {
			local id;

			id = 'cut' + toString(x);
			addVertex(id);
			for(i = 1; i <= blocks.length; i++) {
				if(blocks[i].indexOf(x) == nil)
					continue;
					/*
				for(j = i + 1; j <= blocks.length; j++) {
					if(blocks[j].indexOf(x) == nil)
						continue;
					addEdge('block' + toString(i),
						'block' + toString(j));
				}
				*/
				addEdge(id, 'block' + toString(i));
			}
		});

		return(true);
	}

	recurse(v0, d) {
		local id0, id1;
		local children, isArticulation;
		local blk, e;

		id0 = v0.vertexID;

		visited[id0] = true;
		depth[id0] = d;
		lowpoint[id0] = d;

		children = 0;
		isArticulation = nil;

		v0.getAdjacentVertices().forEach(function(v1) {
			id1 = v1.vertexID;
			if(visited[id1] != true) {
				parent[id1] = id0;

				stack.push([ id0, id1 ]);

				recurse(v1, d + 1);
				children += 1;
				if(lowpoint[id1] >= depth[id0]) {
					isArticulation = true;
					blk = new Vector();
					while(stack.length() > 0) {
						e = stack.pop();
						blk.appendUnique(e[1]);
						blk.appendUnique(e[2]);
						if(((e[1] == id0)
							&& (e[2] == id1))
							|| ((e[1] == id1)
							&& (e[2] == id0)))
							break;
					}
					blocks.append(blk);
				}
				lowpoint[id0] = min(lowpoint[id0],
					lowpoint[id1]);
			} else if(id1 != parent[id0]) {
				if(depth[id0] > depth[id1])
					stack.push([ id0, id1 ]);
				lowpoint[id0] = min(lowpoint[id0], depth[id1]);
			}
		});
		if(((parent[id0] != nil) && isArticulation)
			|| ((parent[id0] == nil) && (children > 1))) {
			articulationPoints.push(id0);
		}
	}
;
