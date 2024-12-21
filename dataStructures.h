//
// dataStructures.h
//

#define nilToInt(v, def) ((v == nil) ? def : toInteger(v))
#define isThing(obj) ((obj != nil) && obj.ofKind(Thing))
#define isAction(obj) ((obj != nil) && obj.ofKind(Action))
#define isLocation(obj) ((obj != nil) && obj.ofKind(BasicLocation))
#define isTuple(obj) ((obj != nil) && obj.ofKind(Tuple))
#define gOutermostRoom(obj) (isThing(obj) ? obj.getOutermostRoom() : nil)
#define noClobber(obj, v) (obj = (obj == nil) ? v : nil)

#define DefineFSM(name, v0) \
	function name() { return(name##FSM.getState()); }; \
	function name##ID() { local st; return(((st = name##FSM.getState()) == nil) ? nil : st.getStateID()); } \
	name##FSM: FSM \
		@v0

FiniteStateMachine template @_vertexList @_edgeMatrix?;

FiniteStateMachineState template 'stateID';

Transition template '_id0' '_id1';


#define isGraph(obj) ((obj != nil) && obj.ofKind(Graph))
#define isVertex(obj) ((obj != nil) && obj.ofKind(Vertex))
#define isEdge(obj) ((obj != nil) && obj.ofKind(Edge))

Vertex template 'vertexID';
Edge template ->vertex1;
Edge template '_id0' '_id1';

Graph template @_vertexList @_edgeMatrix;

#define DeclareGraph(name, v0, v1) \
	name: Graph \
		@v0 \
		@v1


#define isRule(obj) ((obj != nil) && obj.ofKind(Rule))
#define isRulebook(obj) ((obj != nil) && obj.ofKind(Rulebook))

Rule template 'ruleID';


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
