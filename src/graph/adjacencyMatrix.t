#charset "us-ascii"
//
// adjacencyMatrix.t
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

class AdjacencyMatrix: object
	_vertices = nil
	_matrix = nil

	construct(v0?, v1?) {
		if(isList(v0) || isVector(v0)) _vertices = v0;
		if(isMatrix(v1)) _matrix = v1;
	}

	getVertices() { return(_vertices); }
	getMatrix() { return(_matrix); }
	log() {
		local i;
		if(_vertices == nil) {
			"\nno vertices\n ";
		} else {
			"\n";
			for(i = 1; i < _vertices.length; i++)
				"<<toString(_vertices[i])>>, ";
			"<<_vertices[_vertices.length]>>\n ";
		}
		if(_matrix == nil) {
			"\nno matrix\n ";
		} else {
			_matrix.debugMatrix();
		}
	}

	equals(m) {
		if(!isAdjacencyMatrix(m))
			return(nil);
		return(getMatrix().equals(m.getMatrix()));
	}
;
