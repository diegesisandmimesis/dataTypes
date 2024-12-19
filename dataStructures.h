//
// dataStructures.h
//

#define FINITE_STATE_MACHINE
#define GRAPH
#define RULEBOOK
#define TRIGGER

#ifndef nilToInt
#define nilToInt(v, def) ((v == nil) ? def : toInteger(v))
#endif // nilToInt

#ifndef isThing
#define isThing(obj) ((obj != nil) && obj.ofKind(Thing))
#endif // isThing

#ifndef isAction
#define isAction(obj) ((obj != nil) && obj.ofKind(Action))
#endif // isAction

#ifndef isLocation
#define isLocation(obj) ((obj != nil) && obj.ofKind(BasicLocation))
#endif // isLocation

#define isTuple(obj) ((obj != nil) && obj.ofKind(Tuple))

#define gOutermostRoom(obj) (isThing(obj) ? obj.getOutermostRoom() : nil)

#define noClobber(obj, v) (obj = (obj == nil) ? v : nil)

#ifdef FINITE_STATE_MACHINE

#define DefineFSM(name, v0) \
	function name() { return(name##FSM.getState()); }; \
	function name##ID() { local st; return(((st = name##FSM.getState()) == nil) ? nil : st.getStateID()); } \
	name##FSM: FSM \
		@v0

FiniteStateMachine template @_vertexList @_edgeMatrix?;

FiniteStateMachineState template 'stateID';

Transition template '_id0' '_id1';

#endif // FINITE_STATE_MACHINE

#ifdef GRAPH

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

#endif // GRAPH

#ifdef RULEBOOK

#define isRule(obj) ((obj != nil) && obj.ofKind(Rule))
#define isRulebook(obj) ((obj != nil) && obj.ofKind(Rulebook))

Rule template 'ruleID';

#endif // RULEBOOK


#define DATA_STRUCTURES_H
