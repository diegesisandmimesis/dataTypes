#charset "us-ascii"
//
// blockCutTreeTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// Simple test of the basic functionality of the Matrix class.
//
// Creates a couple of matrices, inserts values and then queries them.
//
// It can be compiled via the included makefile with
//
//	# t3make -f blockCutTreeTest.t3m
//
// ...or the equivalent, depending on what TADS development environment
// you're using.
//
// This "game" is distributed under the MIT License, see LICENSE.txt
// for details.
//
#include <adv3.h>
#include <en_us.h>

#include "dataTypes.h"

// .............
// ...A.........
// ../.\........
// .B...C...N...
// ..\./.../.\..
// ...D...I===M.
// ...|...|...|.
// ...E=F=G=H.|.
// .......|...|.
// .....K=J===L.
// .............
versionInfo: GameID;
gameMain: GameMainDef
	newGame() {
		local bct, e0, e1, i, l0, l1;

		bct = new BlockCutTree();
		bct.convert(graph1);

		l0 = bct.getVertexIDs().sort();
		l1 = tree1.getVertexIDs().sort();

		if(!l0.equals(l1)) {
			"\nERROR:  vertex lists don't match\n ";
			return;
		}

		l0 = l0.mapAll({ x: bct.getVertex(x) });
		l1 = l1.mapAll({ x: tree1.getVertex(x) });

		for(i = 1; i <= l0.length; i++) {
			e0 = l0[i].getEdgeIDs().sort();
			e1 = l1[i].getEdgeIDs().sort();
			if(!e0.equals(e1)) {
				"\nERROR: edge lists don't match for
					vertex <<toString(l0[i].vertexID)>>\n ";
				return;
			}
		}

		"\npassed\n ";
	}
;


graph1: Graph
	[ 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N' ]
	[
	//	A  B  C  D  E  F  G  H  I  J  K  L  M  N
		0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // A
		1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // B
		1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // C
		0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // D
		0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0,  // E
		0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0,  // F
		0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0,  // G
		0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,  // H
		0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1,  // I
		0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0,  // J
		0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,  // K
		0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0,  // L
		0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1,  // M
		0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0   // N
	]
;


tree1: Graph
	[ 'block1', 'block2', 'block3', 'block4', 'block5', 'block6', 'block7', 'cutD', 'cutE', 'cutF', 'cutG', 'cutJ' ]
	[
	//	b1 b2 b3 b4 b5 b6 b7 cD cE cF cG cJ
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0,  // block1
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,  // block2
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1,  // block3
		0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0,  // block4
		0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0,  // block5
		0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0,  // block6
		0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,  // block7
		0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0,  // cutD
		0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0,  // cutE
		0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0,  // cutF
		1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0,  // cutG
		0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0   // cutJ
	]
;
