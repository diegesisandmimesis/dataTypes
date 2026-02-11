//
// dataTypes.h
//

//
// General definitions
//

#include "isType.h"

#ifndef inRange
#define inRange(v, r0, r1) \
	(isInteger(v) && isInteger(r0) && isInteger(r1) \
		&& (v >= r0) && (v <= r1))
#endif

// Like adv3's nilToList but for integers
#define nilToInt(v, def) ((v == nil) ? def : toInteger(v))

// Set obj to be v, but only if obj is currently nil
#define noClobber(obj, v) (obj = (obj == nil) ? v : nil)

// Get an object's outermost containing room
#define gOutermostRoom(obj) (isThing(obj) ? obj.getOutermostRoom() : nil)

//
// Graph definitions
//

// Type tests
#define isGraph(obj) (isType(obj, Graph))
#define isVertex(obj) (isType(obj, Vertex))
#define isEdge(obj) (isType(obj, Edge))

#define isAdjacencyMatrix(obj) isType(obj, AdjacencyMatrix)

// Templates
Vertex template 'vertexID';
Edge template ->vertex1;
Edge template '_id1';
Edge template '_id0' '_id1';
Graph template [ _vertexList ] [ _edgeMatrix ];

// Declaration macros
#define DeclareGraph(name, v0, v1) \
	name: Graph \
		v0 \
		v1

//
// State machine definitions
//

// Type tests
#define isFSM(obj) (isType(obj, FiniteStateMachine))

// Templates
FiniteStateMachine template @_vertexList @_edgeMatrix?;
FiniteStateMachineState template 'vertexID';
Transition template '_id0' '_id1';

// Declaration macros
#define DefineFSM(name, v0) \
	function name() { return(name##FSM.getFSMState()); }; \
	function name##ID() { local st; return(((st = name##FSM.getFSMState()) == nil) ? nil : st.getFSMStateID()); } \
	name##FSM: FSM \
		@v0

//
// Markov chain definitions
//

#ifdef MARKOV_CHAINS

#include "intMath.h"
#ifndef INT_MATH_H
#error "The Markov chain functions of this module require the intMath module."
#error "https://github.com/diegesisandmimesis/intMath"
#error "It should be in the same parent directory as this module.  So if"
#error "dataTypes is in /home/user/tads/dataTypes, then"
#error "intMath should be in /home/user/tads/intMath ."
#endif // INT_MATH_H

// Type tests
#define isMarkovChain(obj) (isType(obj, MarkovChain))
#define isMarkovTransition(obj) (isType(obj, MarkovTransition))
#define isMarkovState(obj) (isType(obj, MarkovState))

// Templates
MarkovChain template [ _vertexList ] [ _edgeMatrix ] [ _markovIV ];

#endif // MARKOV_CHAINS

//
// Rulebook definitions
//

// Type tests
#define isRule(obj) (isType(obj, Rule))
#define isRulebook(obj) (isType(obj, Rulebook))

// Templates
Rule template 'ruleID';

// Macro for defining rules that evaluate a single expression.
#define DefineRule(fn) \
	Rule match(data?) { return(fn); } \

//
// Tuple definitions
//

// Type tests
#define isTuple(obj) (isType(obj, Tuple))

// Declaration macros
#define DefineTuple(type, v0, obj0, act0, obj1, act1, a, rm) \
	type \
		ruleID = v0 \
		srcObject = obj0 \
		dstObject = obj1 \
		srcActor = act0 \
		dstActor = act1 \
		action = a##Action \
		room = rm

//
// Trigger definitions
//

// Type tests
#define isTrigger(obj) (isType(obj, Trigger))


//
// HashTable definitions
//

// Type tests
#define isHashTable(obj) (isType(obj, HashTable))


//
// Matrix definitions
//

// Type tests
#define isMatrix(obj) (isType(obj, Matrix))
#define isIntegerMatrix(obj) (isType(obj, IntegerMatrix))


//
// TS definitions
//

// Type tests
#define isTS(obj) (isType(obj, TS))

//
// BT definitions

// Type tests
#define isBTStack(obj) (isType(obj, BTStack))
#define isBTFrame(obj) (isType(obj, BTFrame))
#define isBT(obj) (isType(obj, BT))


//
//  Disjoint Set/Union-Find definitions
//

// Type tests
#define isDisjointSet(obj) isType(obj, DisjointSet)
#define isDisjointSetForest(obj) isType(obj, DisjointSetForest)

//
// AC3 definitions
//

/*
#define makeDisjointSet(v, f) DisjointSet.createInstance(v, f)
#define disjointSetUnion(v0, v1) DisjointForest.union(v0, v1)
#define disjointSetFind(v) DisjointSet.find(v)
*/

//
// Wang Tile definitions
//

WangTile template 'label' [ pattern ];

// Type tests
#define isWangTile(obj) isType(obj, WangTile)


//
// XY declarations
//

#ifdef USE_XY

#include "intMath.h"
#ifndef INT_MATH_H
#error "The XY datatype of this module require the intMath module."
#error "https://github.com/diegesisandmimesis/intMath"
#error "It should be in the same parent directory as this module.  So if"
#error "dataTypes is in /home/user/tads/dataTypes, then"
#error "intMath should be in /home/user/tads/intMath ."
#endif // INT_MATH_H

// Type tests
#define isXY(obj) (isType(obj, XY))

#define isRectangle(obj) (isType(obj, Rectangle))
#define isLineSegment(obj) (isType(obj, LineSegment))
#define isRTree(obj) (isType(obj, RTree))
#define isQuadTree(obj) (isType(obj, QuadTree))
#define isQuadTreeData(obj) (isType(obj, QuadTreeData))

#ifdef USE_ASCII_CANVAS

#define isAsciiCanvas(obj) (isType(obj, AsciiCanvas))

#endif // USE_ASCII_CANVAS

#endif // USE_XY

#ifndef INT_MATH_H
#define _PATCH_SQRT_INT
#endif // INT_MATH_H

#define hasEquals(obj) (isObject(obj) && obj.propDefined(&equals) && (obj.propType(&equals) != TypeNil))

#define DATA_TYPES_H
