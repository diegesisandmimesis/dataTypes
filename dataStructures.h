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

// Like adv3's nilToList but for integers
#define nilToInt(v, def) ((v == nil) ? def : toInteger(v))

// Get an object's outermost containing room
#define gOutermostRoom(obj) (isThing(obj) ? obj.getOutermostRoom() : nil)

// Set obj to be v, but only if obj is currently nil
#define noClobber(obj, v) (obj = (obj == nil) ? v : nil)

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
	function name() { return(name##FSM.getState()); }; \
	function name##ID() { local st; return(((st = name##FSM.getState()) == nil) ? nil : st.getStateID()); } \
	name##FSM: FSM \
		@v0

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
Edge template '_id0' '_id1';
Graph template @_vertexList @_edgeMatrix;

// Declaration macros
#define DeclareGraph(name, v0, v1) \
	name: Graph \
		@v0 \
		@v1

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
