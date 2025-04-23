//
// dataTypes.h
//

//
// General definitions
//

// Utility define for testing an object to see if it is an instance of some
// class
#ifndef isType
#define isType(obj, cls) ((obj != nil) && (dataType(obj) == TypeObject) && obj.ofKind(cls))
#endif

#ifndef isIntrinsicType
#define isIntrinsicType(obj, cls) ((obj != nil) && obj.ofKind(cls))
#endif // isIntrinsicType

// Defines to test for common adv3 object types
#ifndef isThing
#define isThing(obj) (isType(obj, Thing))
#endif
#ifndef isAction
#define isAction(obj) (isType(obj, Action))
#endif
#ifndef isLocation
#define isLocation(obj) (isType(obj, BasicLocation))
#endif
#ifndef isRoom
#define isRoom(obj) (isType(obj, Room))
#endif
#ifndef isActor
#define isActor(obj) (isType(obj, Actor))
#endif

#ifndef isCollection
#define isCollection(obj) (isIntrinsicType(obj, Collection))
#endif
#ifndef isEvent
#define isEvent(obj) (isType(obj, Event))
#endif
#ifndef isList
#define isList(obj) (isIntrinsicType(obj, List))
#endif
#ifndef isObject
#define isObject(obj) ((obj != nil) && (dataType(obj) == TypeObject))
#endif
#ifndef isString
#define isString(obj) ((obj != nil) && (dataType(obj) == TypeSString))
#endif
#ifndef isVector
#define isVector(obj) (isIntrinsicType(obj, Vector))
#endif

#ifndef isEmptyList
#define isEmptyList(obj) (isList(obj) && (obj.length() < 1))
#endif
#ifndef isNilOrEmpty
#define isNilOrEmpty(obj) (!isList(obj) || (obj.length() < 1))
#endif

#ifndef isInteger
#define isInteger(obj) ((obj != nil) && (dataType(obj) == TypeInt))
#endif

#ifndef isFunction
#define isFunction(obj) ((dataType(obj) != TypeNil) && ((dataType(obj) == TypeProp) || (dataType(obj) == TypeCode) || (dataType(obj) == TypeFuncPtr)) || (dataType(obj) == TypeObject))
#endif

#ifndef isDirection
#define isDirection(obj) (isType(obj, Direction))
#endif

#ifndef isDirProp
#define isDirProp(v) ((dataType(v) != TypeNil) && (Direction.allDirections.indexWhich({ x: x.dirProp == v }) != nil))
#endif

#ifndef inRange
#define inRange(v, r0, r1) \
	(isInteger(v) && isInteger(r0) && isInteger(r1) \
		&& (v >= r0) && (v <= r1))
#endif

// Like adv3's nilToList but for integers
#define nilToInt(v, def) ((v == nil) ? def : toInteger(v))

// Set obj to be v, but only if obj is currently nil
#define noClobber(obj, v) (obj = (obj == nil) ? v : nil)

// Define a PRNG test if we don't already have one.
// This is a kludge-within-a-kludge:  we will ALWAYS return nil if isPRNG
// wasn't already defined (because this module doesn't define a PRNG class).
// So in theory we could use "#define isPRNG(obj) (nil)".  But then the
// compiler would complaing about "if(isPRNG(obj)) { [something] }" because
// the conditional stanza will always be unreachable.  So we do the below,
// which will always return nil, but in a less straightforward way.
#ifndef isPRNG
#define isPRNG(obj) ((obj != nil) && nil)
#endif // isPRNG

// Get an object's outermost containing room
#define gOutermostRoom(obj) (isThing(obj) ? obj.getOutermostRoom() : nil)

//
// Graph definitions
//

// Type tests
#define isGraph(obj) (isType(obj, Graph))
#define isVertex(obj) (isType(obj, Vertex))
#define isEdge(obj) (isType(obj, Edge))

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
FiniteStateMachineState template 'stateID';
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
#define isRTree(obj) (isType(obj, RTree))
#define isQuadTree(obj) (isType(obj, QuadTree))
#define isQuadTreeData(obj) (isType(obj, QuadTreeData))

#ifdef USE_ASCII_CANVAS

#define isAsciiCanvas(obj) (isType(obj, AsciiCanvas))

#endif // USE_ASCII_CANVAS

#endif // USE_XY

#define DATA_TYPES_H
