//
// dataStructures.h
//

//
// General definitions
//

// Utility define for testing an object to see if it is an instance of some
// class
#define isType(obj, cls) ((obj != nil) && obj.ofKind(cls))

// Defines to test for common adv3 object types
#define isThing(obj) (isType(obj, Thing))
#define isAction(obj) (isType(obj, Action))
#define isLocation(obj) ((obj != nil) && obj.ofKind(BasicLocation))

#define isObject(obj) ((obj != nil) && (dataType(obj) == TypeObject))
#define isCollection(obj) ((obj != nil) && obj.ofKind(Collection))

#ifndef isInteger
#define isInteger(obj) ((obj != nil) && (dataType(obj) == TypeInt))
#endif // isInteger

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

// Like adv3's nilToList but for integers
#define nilToInt(v, def) ((v == nil) ? def : toInteger(v))

// Get an object's outermost containing room
#define gOutermostRoom(obj) (isThing(obj) ? obj.getOutermostRoom() : nil)

// Set obj to be v, but only if obj is currently nil
#define noClobber(obj, v) (obj = (obj == nil) ? v : nil)

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
#error "dataStructures is in /home/user/tads/dataStructures, then"
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


#ifdef SCENE

#include "beforeAfter.h"
#ifndef BEFORE_AFTER_H
#error "The scene functions of this module require the beforeAfter module."
#error "https://github.com/diegesisandmimesis/beforeAfter"
#error "It should be in the same parent directory as this module.  So if"
#error "dataStructures is in /home/user/tads/dataStructures, then"
#error "beforeAfter should be in /home/user/tads/beforeAfter ."
#endif // BEFORE_AFTER_H

#define isScene(obj) ((obj != nil) && obj.ofKind(Scene))

#endif // SCENE

//TestCase template 'testCaseID'? [ testArgs ];
//#define isTestCase(obj) ((obj != nil) && obj.ofKind(TestCase))

#define DATA_STRUCTURES_H
